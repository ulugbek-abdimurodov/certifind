package com.certifind.repository;

import com.certifind.domain.AccreditedScope;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AccreditedScopeRepository extends JpaRepository<AccreditedScope, Integer> {

    @Query("SELECT DISTINCT s.isoStandard FROM AccreditedScope s ORDER BY s.isoStandard")
    List<String> findDistinctIsoStandards();

    @Query("SELECT DISTINCT s.eaCode FROM AccreditedScope s WHERE s.eaCode IS NOT NULL ORDER BY s.eaCode")
    List<Integer> findDistinctEaCodes();

    @Query("""
        SELECT s FROM AccreditedScope s
        JOIN FETCH s.certificationBody cb
        LEFT JOIN FETCH cb.accreditationBody ab
        WHERE s.isoStandard = :isoStandard
          AND s.status = 'ACTIVE'
        ORDER BY cb.name ASC, s.eaCode ASC
    """)
    List<AccreditedScope> findActiveScopesWithCabAndAbByIso(
        @Param("isoStandard") String isoStandard
    );

    @Query("""
        SELECT s FROM AccreditedScope s
        JOIN FETCH s.certificationBody cb
        ORDER BY cb.id ASC, s.eaCode ASC, s.isoStandard ASC
    """)
    List<AccreditedScope> findAllScopesWithCertificationBody();
}
