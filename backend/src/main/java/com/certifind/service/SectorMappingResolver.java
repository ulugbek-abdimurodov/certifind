package com.certifind.service;

import com.certifind.domain.AtecoEaMapping;
import com.certifind.exception.InvalidSearchRequestException;
import com.certifind.repository.AtecoEaMappingRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class SectorMappingResolver {

    private final AtecoEaMappingRepository atecoEaMappingRepository;

    public SectorMappingResolver(AtecoEaMappingRepository atecoEaMappingRepository) {
        this.atecoEaMappingRepository = atecoEaMappingRepository;
    }

    public AtecoEaMapping resolve(String atecoCode, String sectorActivity) {
        Optional<AtecoEaMapping> mapping = Optional.empty();

        if (atecoCode != null) {
            mapping = atecoEaMappingRepository.findByAtecoCode(atecoCode);
        }
        if (mapping.isEmpty() && sectorActivity != null) {
            mapping = atecoEaMappingRepository
                    .findFirstByDescriptionContainingIgnoreCase(sectorActivity);
        }

        return mapping.orElseThrow(() -> new InvalidSearchRequestException(
                "No sector mapping found. Enter a supported ATECO code or sector activity."));
    }
}
