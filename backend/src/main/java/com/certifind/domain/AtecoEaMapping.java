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

    public Integer getId() {
        return id;
    }

    public String getAtecoCode() {
        return atecoCode;
    }

    public String getDescription() {
        return description;
    }

    public Integer getEaCode() {
        return eaCode;
    }

    public String getEaDescription() {
        return eaDescription;
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
