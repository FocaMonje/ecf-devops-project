import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { EmployeService } from '../../services/employe.service';
import { Employe } from '../../models/employe.model';

@Component({
  selector: 'app-employe-list',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './employe-list.component.html',
  styleUrl: './employe-list.component.css'
})
export class EmployeListComponent implements OnInit {
  employes: Employe[] = [];
  loading = false;
  error = '';

  constructor(private employeService: EmployeService) { }

  ngOnInit(): void {
    this.loadEmployes();
  }

  loadEmployes(): void {
    this.loading = true;
    this.error = '';
    
    this.employeService.getAll().subscribe({
      next: (data) => {
        this.employes = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Erreur lors du chargement des employés';
        this.loading = false;
        console.error('Error:', err);
      }
    });
  }

  deleteEmploye(id: number | undefined): void {
    if (!id) return;
    
    if (confirm('Êtes-vous sûr de vouloir supprimer cet employé ?')) {
      this.employeService.delete(id).subscribe({
        next: () => {
          this.loadEmployes();
        },
        error: (err) => {
          this.error = 'Erreur lors de la suppression';
          console.error('Error:', err);
        }
      });
    }
  }
}
