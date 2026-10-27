package com.certifind.repository;

import com.certifind.domain.CertificationBody;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CertificationBodyRepository extends JpaRepository<CertificationBody, Integer> {
    @Query("""
        SELECT cb FROM CertificationBody cb
        LEFT JOIN FETCH cb.accreditationBody
        ORDER BY cb.name ASC
    """)
    List<CertificationBody> findAllWithAccreditationBody();

    List<CertificationBody> findByCountry(String country);
}
