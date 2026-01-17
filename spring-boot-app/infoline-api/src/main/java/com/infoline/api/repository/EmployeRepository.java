package com.infoline.api.repository;

import com.infoline.api.model.Employe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EmployeRepository extends JpaRepository<Employe, Long> {
    List<Employe> findByDepartementId(Long departementId);
    boolean existsByEmail(String email);
}
