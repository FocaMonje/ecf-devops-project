package com.infoline.api.controller;

import com.infoline.api.model.Departement;
import com.infoline.api.repository.DepartementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/departements")
@CrossOrigin(origins = "*")
public class DepartementController {

    @Autowired
    private DepartementRepository departementRepository;

    // GET tous les départements
    @GetMapping
    public List<Departement> getAllDepartements() {
        return departementRepository.findAll();
    }

    // GET un département par ID
    @GetMapping("/{id}")
    public ResponseEntity<Departement> getDepartementById(@PathVariable Long id) {
        return departementRepository.findById(id)
            .map(departement -> ResponseEntity.ok(departement))
            .orElse(ResponseEntity.notFound().build());
    }

    // POST créer un département
    @PostMapping
    public ResponseEntity<Departement> createDepartement(@Valid @RequestBody Departement departement) {
        if (departementRepository.existsByNom(departement.getNom())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        Departement savedDepartement = departementRepository.save(departement);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedDepartement);
    }

    // PUT mettre à jour un département
    @PutMapping("/{id}")
    public ResponseEntity<Departement> updateDepartement(
            @PathVariable Long id,
            @Valid @RequestBody Departement departementDetails) {

        return departementRepository.findById(id)
            .map(departement -> {
                departement.setNom(departementDetails.getNom());
                departement.setDescription(departementDetails.getDescription());
                Departement updated = departementRepository.save(departement);
                return ResponseEntity.ok(updated);
            })
            .orElse(ResponseEntity.notFound().build());
    }

    // DELETE supprimer un département
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDepartement(@PathVariable Long id) {
        return departementRepository.findById(id)
            .map(departement -> {
                departementRepository.delete(departement);
                return ResponseEntity.ok().<Void>build();
            })
            .orElse(ResponseEntity.notFound().build());
    }
}
