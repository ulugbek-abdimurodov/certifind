package com.certifind.repository;

import com.certifind.domain.AccreditationBody;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AccreditationBodyRepository extends JpaRepository<AccreditationBody, Integer> {
    Optional<AccreditationBody> findByCode(String code);
}
