package com.certifind.repository;

import com.certifind.domain.AtecoEaMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AtecoEaMappingRepository extends JpaRepository<AtecoEaMapping, Integer> {

    Optional<AtecoEaMapping> findByAtecoCode(String atecoCode);

    Optional<AtecoEaMapping> findFirstByDescriptionContainingIgnoreCase(String keyword);
}
