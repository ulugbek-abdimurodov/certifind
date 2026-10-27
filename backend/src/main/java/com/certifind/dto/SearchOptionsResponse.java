package com.certifind.dto;

import java.util.List;

public record SearchOptionsResponse(
    List<String> standards,
    List<SectorOption> sectors
) {}
