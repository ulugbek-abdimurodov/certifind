package com.certifind.repository;

import com.certifind.domain.AccreditedScope;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AccreditedScopeRepository extends JpaRepository<AccreditedScope, Integer> {

    @Query("""
        SELECT s FROM AccreditedScope s
        JOIN FETCH s.certificationBody cb
        LEFT JOIN FETCH cb.accreditationBody ab
        WHERE s.isoStandard = :isoStandard
          AND s.eaCode = :eaCode
          AND s.status = 'ACTIVE'
        ORDER BY COALESCE(cb.customDailyRateEur, ab.avgDailyRateEur) ASC
    """)
    List<AccreditedScope> findActiveScopesWithCabAndAb(
        @Param("isoStandard") String isoStandard,
        @Param("eaCode") Integer eaCode
    );

    List<AccreditedScope> findByIsoStandardAndEaCodeAndStatus(
        String isoStandard,
        Integer eaCode,
        String status
    );
}
