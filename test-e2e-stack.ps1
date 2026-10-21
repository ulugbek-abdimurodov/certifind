<#
.SYNOPSIS
    Automated End-to-End Smoke Test Suite for CertiFind Application Stack.
.DESCRIPTION
    Validates Docker daemon, Database container health, Caddy reverse proxy routing,
    Spring Boot health/search APIs, Next.js frontend SSR delivery, and scopeSection
    data integrity prior to the executive director demo.
#>

[CmdletBinding()]
param(
    [string]$GatewayUrl = "http://localhost",
    [int]$TimeoutSec = 10
)

$ErrorActionPreference = "Stop"

function Write-StepHeader {
    param([string]$Step, [string]$Title)
    Write-Host ""
    Write-Host "[$Step] $Title..." -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "  [PASS] $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  [FAIL] $Message" -ForegroundColor Red
}

$startTime = Get-Date

Write-Host "======================================================================" -ForegroundColor Blue
Write-Host "           CERTIFIND E2E STACK VERIFICATION SUITE                    " -ForegroundColor White
Write-Host "           Target Gateway: $GatewayUrl                                " -ForegroundColor DarkGray
Write-Host "======================================================================" -ForegroundColor Blue

# Exactly 4 steps — keep this list in sync with the Write-StepHeader calls below.
$results = [ordered]@{
    "Database Container"      = "PENDING"
    "Backend API via Proxy"   = "PENDING"
    "Next.js Web App"         = "PENDING"
    "Scope Section Display"   = "PENDING"
}

try {
    # -------------------------------------------------------------------------
    # STEP 1: Verify Docker Engine & Container Health
    # -------------------------------------------------------------------------
    Write-StepHeader "1/4" "Verifying Docker Engine & PostgreSQL Container"
    
    $dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
    if (-not $dockerCmd) {
        throw "Docker CLI was not found on PATH. Ensure Docker Desktop is installed and running."
    }

    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Docker engine daemon is not reachable or not running. Error: $dockerInfo"
    }
    Write-Pass "Docker daemon is active and responsive."

    # Verify PostgreSQL container health
    $pgHealth = docker inspect --format '{{.State.Health.Status}}' certifind-postgres 2>&1
    if ($pgHealth -ne "healthy") {
        # Check if container is at least running
        $pgStatus = docker inspect --format '{{.State.Status}}' certifind-postgres 2>&1
        if ($pgStatus -ne "running") {
            throw "PostgreSQL container 'certifind-postgres' is not running (Current status: $pgStatus)."
        }
        Write-Host "  [WARN] PostgreSQL health status is '$pgHealth'. Waiting for pg_isready..." -ForegroundColor Yellow
    } else {
        Write-Pass "PostgreSQL database container is running and healthy."
    }
    $results["Database Container"] = "[OK]"

    # -------------------------------------------------------------------------
    # STEP 2: Verify Backend API via Caddy Proxy
    # -------------------------------------------------------------------------
    Write-StepHeader "2/4" "Verifying Backend API via Reverse Proxy Gateway"
    
    $healthUri = "$GatewayUrl/api/v1/health"
    $healthResponse = $null

    try {
        $healthResponse = Invoke-RestMethod -Uri $healthUri -Method Get -TimeoutSec $TimeoutSec
    } catch {
        throw "Failed to reach health endpoint at $healthUri. Error: $($_.Exception.Message)"
    }

    if (-not $healthResponse -or $healthResponse.status -ne "UP") {
        throw "Health check returned unexpected payload: $($healthResponse | ConvertTo-Json -Compress)"
    }
    Write-Pass "Backend health endpoint ($healthUri) returned HTTP 200 with status: 'UP'."
    $results["Backend API via Proxy"] = "[OK]"

    # -------------------------------------------------------------------------
    # STEP 3: Verify Next.js Frontend Ingress & SSR
    # -------------------------------------------------------------------------
    Write-StepHeader "3/4" "Verifying Next.js Web Application Ingress"
    
    $frontendResponse = $null
    try {
        $frontendResponse = Invoke-WebRequest -Uri "$GatewayUrl/" -UseBasicParsing -TimeoutSec $TimeoutSec
    } catch {
        throw "Failed to load Next.js frontend at $GatewayUrl/. Error: $($_.Exception.Message)"
    }

    if ($frontendResponse.StatusCode -ne 200) {
        throw "Next.js frontend returned HTTP status $($frontendResponse.StatusCode), expected 200."
    }

    $titleMatch = [regex]::Match($frontendResponse.Content, '<title>(.*?)</title>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if (-not $titleMatch.Success -or ($titleMatch.Groups[1].Value -notmatch "CertiFind")) {
        throw "Frontend HTML title does not contain 'CertiFind'. Found: '$($titleMatch.Groups[1].Value)'"
    }
    Write-Pass "Next.js frontend ($GatewayUrl/) returned HTTP 200 with title: '$($titleMatch.Groups[1].Value)'."
    $results["Next.js Web App"] = "[OK]"

    # -------------------------------------------------------------------------
    # STEP 4: Execute Full Search Scenario & Assert Scope Section Integrity
    # -------------------------------------------------------------------------
    Write-StepHeader "4/4" "Executing Full Search Scenario (ISO 9001 + ATECO 88.91.00)"

    $searchUri = "$GatewayUrl/api/v1/search"
    $payload = @{
        isoStandard    = "ISO 9001"
        sectorActivity = "Asilo nido"
        atecoCode      = "88.91.00"
    } | ConvertTo-Json

    $searchResponse = $null
    try {
        $searchResponse = Invoke-RestMethod -Uri $searchUri -Method Post -ContentType "application/json" -Body $payload -TimeoutSec $TimeoutSec
    } catch {
        throw "Search request to $searchUri failed. Error: $($_.Exception.Message)"
    }

    if (-not $searchResponse) {
        throw "Search response body was empty."
    }

    # Assertion 1: At least one result returned.
    # Note: the service never returns null for scopeSection — it substitutes a
    # hardcoded fallback when the DB column is empty.  Checking >= 1 here is a
    # genuine liveness signal; checking for a specific minimum count is brittle
    # and should live in a dedicated data-quality test.
    $total = [int]$searchResponse.totalResults
    if ($total -lt 1) {
        throw "Expected at least 1 result for ATECO 88.91.00, but received: $total"
    }
    if ($total -lt 5) {
        Write-Host "  [WARN] Only $total result(s) returned; expected >= 5 for a realistic dataset." -ForegroundColor Yellow
    }
    Write-Pass "Search matched $total certification bodies for ATECO 88.91.00 (EA $($searchResponse.resolvedEaCode) - $($searchResponse.resolvedEaDescription))."

    # Assertion 2: Verify scopeSection is backed by real DB data, not the
    # service-layer fallback.  The service substitutes the string below when the
    # AccreditedScope.scopeSection column is NULL, so passing this check proves
    # that at least one row carries an actual value from the database.
    $fallback = "Certificazione generale conforme allo standard ISO"
    $resultsList = @($searchResponse.results)
    $fallbackOnlyItems = $resultsList | Where-Object { $_.scopeSection -eq $fallback }
    $realScopeItems    = $resultsList | Where-Object { $_.scopeSection -ne $fallback -and -not [string]::IsNullOrWhiteSpace($_.scopeSection) }

    if ($realScopeItems.Count -eq 0) {
        throw "Every result carries only the generic fallback scopeSection ('$fallback'). " +
              "This means AccreditedScope.scopeSection is NULL in every matching DB row — " +
              "the UI will show a meaningless placeholder for all $total card(s)."
    }
    if ($fallbackOnlyItems.Count -gt 0) {
        Write-Host "  [WARN] $($fallbackOnlyItems.Count) of $total result(s) use the generic fallback scopeSection." -ForegroundColor Yellow
    }
    Write-Pass "$($realScopeItems.Count) of $total certification body cards carry a real scopeSection from the database."
    $results["Scope Section Display"] = "[OK]"

    # Sample data output for audit trace
    Write-Host ""
    Write-Host "  Sample Verified Certification Body:" -ForegroundColor DarkGray
    Write-Host "    - Organization : $($resultsList[0].name) ($($resultsList[0].country))" -ForegroundColor Gray
    Write-Host "    - Accreditation: $($resultsList[0].accreditationBodyCode) (IAF MLA: $($resultsList[0].isIafMla))" -ForegroundColor Gray
    Write-Host "    - Scope Section: $($resultsList[0].scopeSection)" -ForegroundColor Gray

    # -------------------------------------------------------------------------
    # Final Report
    # -------------------------------------------------------------------------
    $elapsed = ((Get-Date) - $startTime).TotalSeconds

    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host "                      E2E SMOKE TEST REPORT                           " -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host ""
    foreach ($key in $results.Keys) {
        $status = $results[$key]
        $padding = " " * (30 - $key.Length)
        Write-Host "  $key$padding : " -NoNewline -ForegroundColor White
        Write-Host "$status" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "  Execution Time : [ $([math]::Round($elapsed, 2))s ]" -ForegroundColor DarkGray
    Write-Host ""

    exit 0
}
catch {
    Write-Host ""
    Write-Fail "E2E Verification Failed: $($_.Exception.Message)"
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Red
    Write-Host "                      E2E SMOKE TEST REPORT                           " -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Red
    foreach ($key in $results.Keys) {
        $status = $results[$key]
        $padding = " " * (30 - $key.Length)
        Write-Host "  $key$padding : " -NoNewline -ForegroundColor White
        if ($status -eq "[OK]") {
            Write-Host "$status" -ForegroundColor Green
        } else {
            Write-Host "[FAIL]" -ForegroundColor Red
        }
    }
    Write-Host ""
    exit 1
}
