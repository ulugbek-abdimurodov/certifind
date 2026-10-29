package com.certifind.domain;

import java.util.Objects;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "accredited_scopes")
public class AccreditedScope {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "certification_body_id", nullable = false)
    private CertificationBody certificationBody;

    @Column(name = "iso_standard", nullable = false, length = 50)
    private String isoStandard;

    @Column(name = "ea_code")
    private Integer eaCode;

    @Column(name = "scope_section", columnDefinition = "TEXT")
    private String scopeSection;

    @Column(name = "status", nullable = false, length = 20)
    private String status;

    @Column(name = "proof_url", columnDefinition = "TEXT")
    private String proofUrl;

    public Integer getId() {
        return id;
    }

    public CertificationBody getCertificationBody() {
        return certificationBody;
    }

    public String getIsoStandard() {
        return isoStandard;
    }

    public Integer getEaCode() {
        return eaCode;
    }

    public String getScopeSection() {
        return scopeSection;
    }

    public String getProofUrl() {
        return proofUrl;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AccreditedScope that)) return false;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }

    @Override
    public String toString() {
        return "AccreditedScope{" +
                "id=" + id +
                ", isoStandard='" + isoStandard + '\'' +
                ", eaCode=" + eaCode +
                ", scopeSection='" + scopeSection + '\'' +
                ", status='" + status + '\'' +
                ", proofUrl='" + proofUrl + '\'' +
                '}';
    }
}
