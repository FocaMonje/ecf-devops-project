import { Component } from '@angular/core';
imports: [RouterOutlet, RouterLink, RouterLinkActive] from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'InfoLine';
}
