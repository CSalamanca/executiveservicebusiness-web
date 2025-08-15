# 🎨 Guía de Diseño y Estilos - Proyecto Eyenga

## 🌈 Paleta de Colores

### Colores Principales

```css
:root {
  /* Colores base */
  --primary-color: #16a085; /* Verde principal */
  --secondary-color: #e74c3c; /* Rojo de acento */
  --accent-color: #f39c12; /* Naranja vibrante */
  --text-dark: #2c3e50; /* Texto principal */
  --text-light: #7f8c8d; /* Texto secundario */
  --white: #ffffff; /* Blanco */
  --light-gray: #ecf0f1; /* Gris claro */

  /* Gradientes */
  --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --gradient-warm: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --gradient-cool: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  --gradient-sunset: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
  --gradient-ocean: linear-gradient(135deg, #2196f3 0%, #00bcd4 100%);
  --gradient-forest: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);

  /* Sombras */
  --shadow-soft: 0 5px 15px rgba(0, 0, 0, 0.08);
  --shadow-medium: 0 10px 25px rgba(0, 0, 0, 0.15);
  --shadow-strong: 0 15px 35px rgba(0, 0, 0, 0.2);
  --shadow-colored: 0 10px 25px rgba(22, 160, 133, 0.3);
}
```

### Uso de Gradientes por Sección

| Sección          | Gradiente          | Propósito                   |
| ---------------- | ------------------ | --------------------------- |
| **Hero**         | `gradient-primary` | Elegancia profesional       |
| **Estadísticas** | `gradient-cool`    | Confianza y modernidad      |
| **Programas**    | `gradient-warm`    | Calidez educativa           |
| **Galería**      | `gradient-forest`  | Naturaleza y sostenibilidad |
| **CTA**          | `gradient-sunset`  | Urgencia y acción           |
| **Footer**       | `gradient-ocean`   | Profundidad y estabilidad   |

## 📱 Responsive Design

### Breakpoints Definidos

```css
/* Mobile First Approach */
/* Base: 320px+ (móvil) */

/* Tablet */
@media (max-width: 1024px) {
  /* Estilos para tablet */
}

/* Móvil */
@media (max-width: 768px) {
  /* Estilos para móvil */
}
```

### Adaptaciones por Dispositivo

#### 🖥️ Desktop (1025px+)

- **Navegación**: Menú horizontal expandido
- **Hero**: Layout de dos columnas
- **Galería**: Grid de 3 columnas
- **Flechas de scroll**: 60px × 60px

#### 📱 Tablet (769px - 1024px)

- **Navegación**: Menú hamburguesa
- **Hero**: Layout de una columna
- **Galería**: Grid de 2 columnas
- **Flechas de scroll**: 50px × 50px

#### 📱 Móvil (≤768px)

- **Navegación**: Menú hamburguesa compacto
- **Hero**: Layout vertical
- **Galería**: Grid de 1 columna
- **Flechas de scroll**: 40px × 40px

## 🎭 Sistema de Animaciones

### Animaciones de Entrada (ScrollReveal)

```css
.scroll-reveal {
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.scroll-reveal-visible {
  opacity: 1;
  transform: translateY(0);
}
```

### Animaciones de Flechas de Scroll

```css
@keyframes bounceDown {
  0%,
  20%,
  50%,
  80%,
  100% {
    transform: translateY(0);
  }
  10% {
    transform: translateY(-3px);
  }
  30% {
    transform: translateY(-6px);
  }
  40% {
    transform: translateY(-3px);
  }
}

@keyframes bounceUp {
  0%,
  20%,
  50%,
  80%,
  100% {
    transform: translateY(0);
  }
  10% {
    transform: translateY(3px);
  }
  30% {
    transform: translateY(6px);
  }
  40% {
    transform: translateY(3px);
  }
}
```

### Efectos Hover

```css
/* Cards de programas */
.feature-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

/* Botones */
.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

/* Imágenes de galería */
.gallery-image:hover {
  transform: scale(1.05);
}
```

## 🖼️ Sistema de Imágenes

### Estructura de Assets

```
src/assets/
├── eyenga-laboratorio.png          # Laboratorios (galería)
├── eyenga-agricultura_sostenible.png  # Agricultura (galería)
├── eyenga-construccion_sostenible.png # Construcción (galería)
├── eyenga-ganaderia_sostenible.png    # Ganadería (galería)
├── image001.png                    # Campus Congo-Brazzaville
├── image002.jpg                    # Campus Madrid
├── image004.png                    # Instalaciones generales
├── image005.png                    # Sobre nosotros
├── image006.png                    # Programa 1 (no usado)
├── image007.png                    # Programa 2 (no usado)
├── image008.png                    # Programa 3 (no usado)
└── image010.png                    # Hero y logo
```

### Optimización de Imágenes

```css
/* Estilos base para imágenes */
.gallery-image {
  width: 100%;
  height: 300px;
  object-fit: cover;
  border-radius: 15px;
  transition: transform 0.3s ease;
}

/* Logo en navegación */
.logo-icon {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
}

/* Imagen hero */
.hero-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 10px;
}
```

## 🧩 Componentes Reutilizables

### ContactModal

```tsx
interface ContactModalProps {
  isOpen: boolean;
  onClose: () => void;
}

// Características:
// - Backdrop con blur
// - Formulario responsive
// - Validación básica
// - Animaciones de entrada/salida
```

### ScrollReveal

```tsx
interface ScrollRevealProps {
  children: React.ReactNode;
  delay?: number;
}

// Características:
// - Intersection Observer API
// - Delays configurables
// - Reutilizable en cualquier sección
```

### Navegación Inteligente

```typescript
// Lógica de flechas de scroll
const handleScroll = () => {
  const currentScrollY = window.scrollY;
  const documentHeight = document.documentElement.scrollHeight;
  const windowHeight = window.innerHeight;
  const maxScroll = documentHeight - windowHeight;

  // Flecha arriba: visible cuando no estás en el top
  setShowUpArrow(currentScrollY > 100);

  // Flecha abajo: visible cuando no estás en el bottom
  setShowDownArrow(currentScrollY < maxScroll - 100);
};
```

## 📐 Layout y Espaciado

### Sistema de Espaciado

```css
/* Espaciado consistente */
.section {
  padding: 6rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

/* Espaciado interno */
.section-header {
  margin-bottom: 4rem;
  text-align: center;
}

.feature-card {
  padding: 3rem 2rem;
  margin-bottom: 2rem;
}
```

### Grid Systems

```css
/* Grid de estadísticas */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

/* Grid de programas */
.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

/* Grid de galería */
.gallery-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
}
```

## 🎯 Guías de Usabilidad

### Navegación

- **Scroll suave**: Animado entre secciones
- **Flechas inteligentes**: Aparecen/desaparecen según contexto
- **Menú sticky**: Siempre accesible
- **Enlaces activos**: Feedback visual

### Interactividad

- **Hover states**: En todos los elementos clickeables
- **Loading states**: Feedback durante transiciones
- **Focus states**: Accesibilidad con teclado
- **Touch targets**: Mínimo 44px en móvil

### Feedback Visual

- **Estados de carga**: Spinners o animaciones
- **Estados de error**: Mensajes claros
- **Estados de éxito**: Confirmaciones visuales
- **Transiciones**: Suaves y naturales

## 🔧 Mejores Prácticas

### CSS

1. **Mobile First**: Escribir estilos base para móvil
2. **Variables CSS**: Usar custom properties
3. **BEM Methodology**: Nomenclatura consistente
4. **Performance**: Evitar animaciones costosas

### Imágenes

1. **Formato**: WebP cuando sea posible, PNG/JPG como fallback
2. **Compresión**: Optimizar para web
3. **Alt text**: Descripción significativa
4. **Lazy loading**: Implementar para performance

### Accesibilidad

1. **Contraste**: Mínimo 4.5:1 para texto
2. **Focus**: Indicadores visibles
3. **ARIA**: Labels y roles apropiados
4. **Keyboard**: Navegación completa por teclado

---

**Versión**: v1.0  
**Última actualización**: 15 de Agosto, 2025  
**Mantenido por**: Equipo de Desarrollo Eyenga
