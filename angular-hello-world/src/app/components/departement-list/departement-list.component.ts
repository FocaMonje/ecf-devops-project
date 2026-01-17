import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { DepartementService } from '../../services/departement.service';
import { Departement } from '../../models/departement.model';

@Component({
  selector: 'app-departement-list',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './departement-list.component.html',
  styleUrl: './departement-list.component.css'
})
export class DepartementListComponent implements OnInit {
  departements: Departement[] = [];
  loading = false;
  error = '';

  constructor(private departementService: DepartementService) { }

  ngOnInit(): void {
    this.loadDepartements();
  }

  loadDepartements(): void {
    this.loading = true;
    this.error = '';
    
    this.departementService.getAll().subscribe({
      next: (data) => {
        this.departements = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Erreur lors du chargement des départements';
        this.loading = false;
        console.error('Error:', err);
      }
    });
  }

  deleteDepartement(id: number | undefined): void {
    if (!id) return;
    
    if (confirm('Êtes-vous sûr de vouloir supprimer ce département ?')) {
      this.departementService.delete(id).subscribe({
        next: () => {
          this.loadDepartements();
        },
        error: (err) => {
          this.error = 'Erreur lors de la suppression';
          console.error('Error:', err);
        }
      });
    }
  }
}
