package com.certifind.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ea_sector")
public class EaSector {

    @Id
    private Integer code;

    @Column(name = "name_en", nullable = false, length = 200)
    private String nameEn;

    public Integer getCode() {
        return code;
    }

    public String getNameEn() {
        return nameEn;
    }
}
