package com.certifind.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.util.Objects;

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

    @Column(name = "ea_code", nullable = false)
    private Integer eaCode;

    @Column(name = "status", nullable = false, length = 20)
    private String status = "ACTIVE";

    @Column(name = "proof_url", columnDefinition = "TEXT")
    private String proofUrl;

    public AccreditedScope() {
    }

    public AccreditedScope(CertificationBody certificationBody, String isoStandard, Integer eaCode, String status, String proofUrl) {
        this.certificationBody = certificationBody;
        this.isoStandard = isoStandard;
        this.eaCode = eaCode;
        this.status = status;
        this.proofUrl = proofUrl;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public CertificationBody getCertificationBody() {
        return certificationBody;
    }

    public void setCertificationBody(CertificationBody certificationBody) {
        this.certificationBody = certificationBody;
    }

    public String getIsoStandard() {
        return isoStandard;
    }

    public void setIsoStandard(String isoStandard) {
        this.isoStandard = isoStandard;
    }

    public Integer getEaCode() {
        return eaCode;
    }

    public void setEaCode(Integer eaCode) {
        this.eaCode = eaCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProofUrl() {
        return proofUrl;
    }

    public void setProofUrl(String proofUrl) {
        this.proofUrl = proofUrl;
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
                ", status='" + status + '\'' +
                ", proofUrl='" + proofUrl + '\'' +
                '}';
    }
}
