import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute, RouterLink } from '@angular/router';
import { DepartementService } from '../../services/departement.service';
import { Departement } from '../../models/departement.model';

@Component({
  selector: 'app-departement-form',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './departement-form.component.html',
  styleUrl: './departement-form.component.css'
})
export class DepartementFormComponent implements OnInit {
  departement: Departement = {
    nom: '',
    description: ''
  };
  
  isEditMode = false;
  departementId?: number;
  error = '';
  loading = false;

  constructor(
    private departementService: DepartementService,
    private router: Router,
    private route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.departementId = +id;
      this.loadDepartement(this.departementId);
    }
  }

  loadDepartement(id: number): void {
    this.loading = true;
    this.departementService.getById(id).subscribe({
      next: (data) => {
        this.departement = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Erreur lors du chargement du département';
        this.loading = false;
        console.error('Error:', err);
      }
    });
  }

  onSubmit(): void {
    this.error = '';
    this.loading = true;

    if (this.isEditMode && this.departementId) {
      this.departementService.update(this.departementId, this.departement).subscribe({
        next: () => {
          this.router.navigate(['/departements']);
        },
        error: (err) => {
          this.error = 'Erreur lors de la modification';
          this.loading = false;
          console.error('Error:', err);
        }
      });
    } else {
      this.departementService.create(this.departement).subscribe({
        next: () => {
          this.router.navigate(['/departements']);
        },
        error: (err) => {
          this.error = 'Erreur lors de la création';
          this.loading = false;
          console.error('Error:', err);
        }
      });
    }
  }
}
