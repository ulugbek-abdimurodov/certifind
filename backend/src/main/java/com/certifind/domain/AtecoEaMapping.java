package com.certifind.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.Objects;

@Entity
@Table(name = "ateco_ea_mapping")
public class AtecoEaMapping {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "ateco_code", nullable = false, length = 20)
    private String atecoCode;

    @Column(name = "description", nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "ea_code", nullable = false)
    private Integer eaCode;

    @Column(name = "ea_description", nullable = false, length = 255)
    private String eaDescription;

    public AtecoEaMapping() {
    }

    public AtecoEaMapping(String atecoCode, String description, Integer eaCode, String eaDescription) {
        this.atecoCode = atecoCode;
        this.description = description;
        this.eaCode = eaCode;
        this.eaDescription = eaDescription;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAtecoCode() {
        return atecoCode;
    }

    public void setAtecoCode(String atecoCode) {
        this.atecoCode = atecoCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getEaCode() {
        return eaCode;
    }

    public void setEaCode(Integer eaCode) {
        this.eaCode = eaCode;
    }

    public String getEaDescription() {
        return eaDescription;
    }

    public void setEaDescription(String eaDescription) {
        this.eaDescription = eaDescription;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AtecoEaMapping that)) return false;
        return Objects.equals(id, that.id) || (atecoCode != null && Objects.equals(atecoCode, that.atecoCode));
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(atecoCode != null ? atecoCode : id);
    }

    @Override
    public String toString() {
        return "AtecoEaMapping{" +
                "id=" + id +
                ", atecoCode='" + atecoCode + '\'' +
                ", description='" + description + '\'' +
                ", eaCode=" + eaCode +
                ", eaDescription='" + eaDescription + '\'' +
                '}';
    }
}
