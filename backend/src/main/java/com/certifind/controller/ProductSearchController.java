package com.certifind.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.certifind.dto.ProductDtos;
import com.certifind.service.ProductSearchService;

/** Product, process and service certification (ISO/IEC 17065), next to the management system search. */
@RestController
@RequestMapping("/api/v1")
public class ProductSearchController {

    private final ProductSearchService service;

    public ProductSearchController(ProductSearchService service) {
        this.service = service;
    }

    @GetMapping("/product-options")
    public ResponseEntity<ProductDtos.Options> options() {
        return ResponseEntity.ok(service.getOptions());
    }

    @PostMapping("/product-search")
    public ResponseEntity<ProductDtos.SearchResponse> search(@RequestBody ProductDtos.SearchRequest request) {
        // Invalid input throws IllegalArgumentException; ApiExceptionHandler turns it into a 400 problem.
        return ResponseEntity.ok(service.search(request));
    }

    /** Every body with a valid product scope, for "Vedi tutti gli organismi". */
    @GetMapping("/product-companies")
    public ResponseEntity<ProductDtos.SearchResponse> allCompanies() {
        return ResponseEntity.ok(service.findAll());
    }

    /** Every valid scope line of one body, for the detail drawer. */
    @GetMapping("/companies/{id}/product-scopes")
    public ResponseEntity<List<ProductDtos.ScopeLine>> companyScopes(@PathVariable Integer id) {
        return ResponseEntity.ok(service.findScopes(id));
    }
}
