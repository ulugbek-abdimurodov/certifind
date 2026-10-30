package com.certifind.repository;

import com.certifind.domain.AccreditedScope;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Every query here returns only valid issuing rights: the scope and its accreditation
 * are ACTIVE and the accreditation has not expired (same rule as the v_issuing_rights view).
 */
@Repository
public interface AccreditedScopeRepository extends JpaRepository<AccreditedScope, Integer> {

    @Query("""
        SELECT DISTINCT s.certificationStandard FROM AccreditedScope s JOIN s.accreditation a
        WHERE s.status = 'ACTIVE' AND a.status = 'ACTIVE'
          AND (a.expiryDate IS NULL OR a.expiryDate >= CURRENT_DATE)
        ORDER BY s.certificationStandard
    """)
    List<String> findDistinctCertificationStandards();

    @Query("""
        SELECT DISTINCT s.eaCode FROM AccreditedScope s JOIN s.accreditation a
        WHERE s.status = 'ACTIVE' AND a.status = 'ACTIVE'
          AND (a.expiryDate IS NULL OR a.expiryDate >= CURRENT_DATE)
        ORDER BY s.eaCode
    """)
    List<Integer> findDistinctEaCodes();

    @Query("""
        SELECT s FROM AccreditedScope s
        JOIN FETCH s.accreditation a
        JOIN FETCH a.certificationBody cb
        JOIN FETCH a.accreditationBody ab
        WHERE s.certificationStandard = :standard
          AND s.status = 'ACTIVE' AND a.status = 'ACTIVE'
          AND (a.expiryDate IS NULL OR a.expiryDate >= CURRENT_DATE)
        ORDER BY cb.name ASC, s.eaCode ASC
    """)
    List<AccreditedScope> findValidScopesByStandard(@Param("standard") String standard);

    @Query("""
        SELECT s FROM AccreditedScope s
        JOIN FETCH s.accreditation a
        JOIN FETCH a.certificationBody cb
        JOIN FETCH a.accreditationBody ab
        WHERE s.status = 'ACTIVE' AND a.status = 'ACTIVE'
          AND (a.expiryDate IS NULL OR a.expiryDate >= CURRENT_DATE)
        ORDER BY cb.id ASC, s.certificationStandard ASC, s.eaCode ASC
    """)
    List<AccreditedScope> findAllValidScopes();
}
