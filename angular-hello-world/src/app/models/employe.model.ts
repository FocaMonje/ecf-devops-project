export interface Employe {
  id?: number;
  prenom: string;
  nom: string;
  email: string;
  poste: string;
  departement?: Departement;
}

export interface Departement {
  id?: number;
  nom: string;
  description?: string;
}
