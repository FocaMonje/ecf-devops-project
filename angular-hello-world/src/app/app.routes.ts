import { Routes } from '@angular/router';
import { HomeComponent } from './components/home/home.component';
import { EmployeListComponent } from './components/employe-list/employe-list.component';
import { EmployeFormComponent } from './components/employe-form/employe-form.component';
import { DepartementListComponent } from './components/departement-list/departement-list.component';
import { DepartementFormComponent } from './components/departement-form/departement-form.component';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'employes', component: EmployeListComponent },
  { path: 'employes/new', component: EmployeFormComponent },
  { path: 'employes/edit/:id', component: EmployeFormComponent },
  { path: 'departements', component: DepartementListComponent },
  { path: 'departements/new', component: DepartementFormComponent },
  { path: 'departements/edit/:id', component: DepartementFormComponent },
  { path: '**', redirectTo: '' }
];
