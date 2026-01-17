package com.infoline.api.controller;

import com.infoline.api.model.Employe;
import com.infoline.api.repository.EmployeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/employes")
@CrossOrigin(origins = "*")
public class EmployeController {

    @Autowired
    private EmployeRepository employeRepository;

    // GET tous les employés
    @GetMapping
    public List<Employe> getAllEmployes() {
        return employeRepository.findAll();
    }

    // GET un employé par ID
    @GetMapping("/{id}")
    public ResponseEntity<Employe> getEmployeById(@PathVariable Long id) {
        return employeRepository.findById(id)
            .map(employe -> ResponseEntity.ok(employe))
            .orElse(ResponseEntity.notFound().build());
    }

    // GET employés par département
    @GetMapping("/departement/{departementId}")
    public List<Employe> getEmployesByDepartement(@PathVariable Long departementId) {
        return employeRepository.findByDepartementId(departementId);
    }

    // POST créer un employé
    @PostMapping
    public ResponseEntity<Employe> createEmploye(@Valid @RequestBody Employe employe) {
        if (employeRepository.existsByEmail(employe.getEmail())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        Employe savedEmploye = employeRepository.save(employe);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedEmploye);
    }

    // PUT mettre à jour un employé
    @PutMapping("/{id}")
    public ResponseEntity<Employe> updateEmploye(
            @PathVariable Long id,
            @Valid @RequestBody Employe employeDetails) {

        return employeRepository.findById(id)
            .map(employe -> {
                employe.setPrenom(employeDetails.getPrenom());
                employe.setNom(employeDetails.getNom());
                employe.setEmail(employeDetails.getEmail());
                employe.setPoste(employeDetails.getPoste());
                Employe updated = employeRepository.save(employe);
                return ResponseEntity.ok(updated);
            })
            .orElse(ResponseEntity.notFound().build());
    }

    // DELETE supprimer un employé
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEmploye(@PathVariable Long id) {
        return employeRepository.findById(id)
            .map(employe -> {
                employeRepository.delete(employe);
                return ResponseEntity.ok().<Void>build();
            })
            .orElse(ResponseEntity.notFound().build());
    }
}
