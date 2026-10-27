package com.certifind.repository;

import com.certifind.domain.EaSector;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EaSectorRepository extends JpaRepository<EaSector, Integer> {
    List<EaSector> findAllByOrderByCodeAsc();
}
