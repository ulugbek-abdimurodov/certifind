#!/bin/sh
# Serves CertiFind through the host's own nginx, for a server where ports 80/443
# already belong to it (other sites). Use instead of the proxy/certbot services.
# Run on the server, after the backend and frontend containers are up:
#   sudo sh /opt/certifind/deploy/install-host-nginx.sh
#
# Writes /etc/nginx/sites-enabled/certifind.conf from nginx/host-certifind.conf.template
# (API_DOMAIN, BACKEND_PORT, FRONTEND_PORT from deploy/.env), gets a Let's Encrypt
# certificate with the host's certbot if there is none yet, and reloads nginx.
# Every reload is preceded by "nginx -t"; on a failed test the previous file is
# restored, so other sites keep working. Safe to run again after editing the template.
set -eu

DIR=$(cd "$(dirname "$0")" && pwd)
SITE=/etc/nginx/sites-enabled/certifind.conf
WEBROOT=/var/www/certbot

[ "$(id -u)" = 0 ] || { echo "Run with sudo." >&2; exit 1; }
command -v nginx >/dev/null || { echo "nginx is not installed on the host." >&2; exit 1; }
command -v certbot >/dev/null || { echo "certbot is not installed on the host." >&2; exit 1; }

env_value() { sed -n "s/^$1=//p" "$DIR/.env" | tail -1; }
API_DOMAIN=$(env_value API_DOMAIN)
LETSENCRYPT_EMAIL=$(env_value LETSENCRYPT_EMAIL)
BACKEND_PORT=$(env_value BACKEND_PORT); BACKEND_PORT=${BACKEND_PORT:-8080}
FRONTEND_PORT=$(env_value FRONTEND_PORT); FRONTEND_PORT=${FRONTEND_PORT:-3100}
[ -n "$API_DOMAIN" ] || { echo "Set API_DOMAIN in deploy/.env." >&2; exit 1; }

# Prints the site config; with "http-only", without the HTTPS server block.
render() {
    sed -e "s|\${API_DOMAIN}|$API_DOMAIN|g" \
        -e "s|\${BACKEND_PORT}|$BACKEND_PORT|g" \
        -e "s|\${FRONTEND_PORT}|$FRONTEND_PORT|g" \
        "$DIR/nginx/host-certifind.conf.template" |
    if [ "${1:-}" = http-only ]; then sed '/^# --- HTTPS/,$d'; else cat; fi
}

# Installs a config, tests it, reloads nginx; restores the previous state on failure.
install_site() {
    backup=$(mktemp)
    had_site=no
    if [ -f "$SITE" ]; then cp "$SITE" "$backup"; had_site=yes; fi
    render "${1:-}" > "$SITE"
    if nginx -t 2>/dev/null; then
        systemctl reload nginx
        rm -f "$backup"
    else
        nginx -t || true
        if [ "$had_site" = yes ]; then cp "$backup" "$SITE"; else rm -f "$SITE"; fi
        rm -f "$backup"
        echo "nginx config test failed; previous config restored, nginx not reloaded." >&2
        exit 1
    fi
}

mkdir -p "$WEBROOT"

if [ ! -f "/etc/letsencrypt/live/$API_DOMAIN/fullchain.pem" ]; then
    [ -n "$LETSENCRYPT_EMAIL" ] || { echo "Set LETSENCRYPT_EMAIL in deploy/.env." >&2; exit 1; }
    echo "No certificate for $API_DOMAIN yet: serving HTTP only to answer the challenge."
    install_site http-only
    certbot certonly --webroot -w "$WEBROOT" -d "$API_DOMAIN" \
        --email "$LETSENCRYPT_EMAIL" --agree-tos --no-eff-email -n
fi

# Renewals (host certbot timer) must reload nginx to use the new certificate.
RENEWAL=/etc/letsencrypt/renewal/$API_DOMAIN.conf
if [ -f "$RENEWAL" ] && ! grep -q '^renew_hook' "$RENEWAL"; then
    sed -i '/^\[renewalparams\]/a renew_hook = systemctl reload nginx' "$RENEWAL"
fi

install_site
echo "Done: https://$API_DOMAIN/"
