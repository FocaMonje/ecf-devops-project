import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute, RouterLink } from '@angular/router';
import { EmployeService } from '../../services/employe.service';
import { Employe } from '../../models/employe.model';

@Component({
  selector: 'app-employe-form',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './employe-form.component.html',
  styleUrl: './employe-form.component.css'
})
export class EmployeFormComponent implements OnInit {
  employe: Employe = {
    prenom: '',
    nom: '',
    email: '',
    poste: ''
  };
  
  isEditMode = false;
  employeId?: number;
  error = '';
  loading = false;

  constructor(
    private employeService: EmployeService,
    private router: Router,
    private route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.employeId = +id;
      this.loadEmploye(this.employeId);
    }
  }

  loadEmploye(id: number): void {
    this.loading = true;
    this.employeService.getById(id).subscribe({
      next: (data) => {
        this.employe = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Erreur lors du chargement de l\'employé';
        this.loading = false;
        console.error('Error:', err);
      }
    });
  }

  onSubmit(): void {
    this.error = '';
    this.loading = true;

    if (this.isEditMode && this.employeId) {
      this.employeService.update(this.employeId, this.employe).subscribe({
        next: () => {
          this.router.navigate(['/employes']);
        },
        error: (err) => {
          this.error = 'Erreur lors de la modification';
          this.loading = false;
          console.error('Error:', err);
        }
      });
    } else {
      this.employeService.create(this.employe).subscribe({
        next: () => {
          this.router.navigate(['/employes']);
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
