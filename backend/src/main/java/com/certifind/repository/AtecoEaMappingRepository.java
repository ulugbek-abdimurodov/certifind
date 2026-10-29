package com.certifind.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.certifind.domain.AtecoEaMapping;

@Repository
public interface AtecoEaMappingRepository extends JpaRepository<AtecoEaMapping, Integer> {

    Optional<AtecoEaMapping> findFirstByAtecoCode(String atecoCode);

    Optional<AtecoEaMapping> findFirstByDescriptionContainingIgnoreCase(String keyword);

    Optional<AtecoEaMapping> findFirstByEaDescriptionContainingIgnoreCase(String keyword);
}
