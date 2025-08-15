import React, { useState, useEffect } from "react";
import "./App.css";
import ScrollReveal from "./components/ScrollReveal";
import ContactModal from "./components/ContactModal";

// Importar imágenes
import campusImage1 from "./assets/image001.png";
import campusImage2 from "./assets/image002.jpg";
import facilityImage2 from "./assets/image005.png";
import heroImage from "./assets/image010.png";
import logoIcon from "./assets/image010.png";
// Importar imágenes específicas de Eyenga
import laboratorioImage from "./assets/eyenga-laboratorio.png";
import agriculturaImage from "./assets/eyenga-agricultura_sostenible.png";
import construccionImage from "./assets/eyenga-construccion_sostenible.png";
import ganaderiaImage from "./assets/eyenga-ganaderia_sostenible.png";

function App() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isContactModalOpen, setIsContactModalOpen] = useState(false);
  const [showUpArrow, setShowUpArrow] = useState(false);
  const [showDownArrow, setShowDownArrow] = useState(true);

  useEffect(() => {
    let ticking = false;

    const handleScroll = () => {
      if (!ticking) {
        requestAnimationFrame(() => {
          const currentScrollY = window.scrollY;
          const documentHeight = document.documentElement.scrollHeight;
          const windowHeight = window.innerHeight;
          const maxScroll = documentHeight - windowHeight;

          // Actualizar si está en la parte superior
          setIsScrolled(currentScrollY > 100);

          // Lógica para mostrar/ocultar flechas
          // Flecha hacia arriba: se muestra cuando no estás en el top (con un pequeño margen)
          setShowUpArrow(currentScrollY > 100);

          // Flecha hacia abajo: se muestra cuando no estás en el bottom (con un pequeño margen)
          setShowDownArrow(currentScrollY < maxScroll - 100);

          ticking = false;
        });
        ticking = true;
      }
    };

    // Inicializar
    handleScroll();

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);
  const scrollToSection = (sectionId: string) => {
    const element = document.getElementById(sectionId);
    if (element) {
      element.scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    }
    setIsMenuOpen(false); // Cerrar menú móvil después de hacer clic
  };

  const handleScrollUpClick = () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  };

  const handleScrollDownClick = () => {
    // Encontrar la siguiente sección visible
    const sections = ["home", "features", "gallery", "about", "contact"];
    const currentScrollY = window.scrollY;

    // Encontrar la siguiente sección
    for (let i = 0; i < sections.length; i++) {
      const element = document.getElementById(sections[i]);
      if (element) {
        const rect = element.getBoundingClientRect();
        const elementTop = rect.top + currentScrollY;

        if (elementTop > currentScrollY + 100) {
          element.scrollIntoView({
            behavior: "smooth",
            block: "start",
          });
          return;
        }
      }
    }

    // Si no hay siguiente sección, ir al final
    window.scrollTo({
      top: document.documentElement.scrollHeight,
      behavior: "smooth",
    });
  };

  const features = [
    {
      icon: "🌾",
      title: "Formación Técnica Integral",
      description:
        "Educación especializada en agricultura, ganadería y construcción con un enfoque práctico y teórico riguroso",
    },
    {
      icon: "🏫",
      title: "Campus Multinacionales",
      description:
        "Sedes en Congo-Brazzaville (100 ha) y Madrid (16 ha) con intercambio académico y tecnológico",
    },
    {
      icon: "👩‍🌾",
      title: "Inclusión Social",
      description:
        "Programas especiales para mujeres en situación vulnerable y comunidades locales",
    },
    {
      icon: "🔬",
      title: "Laboratorio Multifuncional",
      description:
        "Análisis de suelos, alimentos y sangre abierto a terceros para certificación e investigación",
    },
    {
      icon: "🌱",
      title: "Sostenibilidad Ambiental",
      description:
        "Energías renovables, manejo de residuos y técnicas de construcción sostenible",
    },
    {
      icon: "🤝",
      title: "Inserción Laboral Garantizada",
      description:
        "Tasa de inserción superior al 90% mediante convenios con empresas y cooperativas",
    },
  ];

  const stats = [
    { number: "2600", label: "Estudiantes Proyectados (5 años)" },
    { number: "90%", label: "Tasa de Inserción Laboral" },
    { number: "116 Ha", label: "Superficie Total de Campus" },
    { number: "17%", label: "Crecimiento Anual Proyectado" },
  ];

  return (
    <div className="App">
      {/* Navigation */}
      <nav className={`navbar ${isScrolled ? "navbar-scrolled" : ""}`}>
        <div className="nav-container">
          <div className="nav-logo">
            <img
              src={logoIcon}
              alt="Eyenga Logo"
              className="logo-icon"
              style={{
                width: "32px",
                height: "32px",
                borderRadius: "50%",
                objectFit: "cover",
              }}
            />
            <span className="logo-text">Eyenga</span>
          </div>

          <div className={`nav-menu ${isMenuOpen ? "nav-menu-active" : ""}`}>
            <button
              className="nav-link"
              onClick={() => scrollToSection("home")}
            >
              Inicio
            </button>
            <button
              className="nav-link"
              onClick={() => scrollToSection("features")}
            >
              Programas
            </button>
            <button
              className="nav-link"
              onClick={() => scrollToSection("about")}
            >
              Nosotros
            </button>
            <button
              className="nav-link"
              onClick={() => scrollToSection("contact")}
            >
              Contacto
            </button>
          </div>

          <div
            className="nav-hamburger"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section id="home" className="hero">
        <div className="hero-background">
          <div className="hero-particles"></div>
        </div>
        <div className="hero-container">
          <div className="hero-content">
            <h1 className="hero-title">
              Bienvenido a <span className="highlight">Eyenga</span>
            </h1>
            <p className="hero-subtitle">
              Un gran árbol tecnológico que une lo rural y lo urbano.
              Institución líder en formación técnica rural y urbana en África
              Central y Europa, reconocida por su excelencia académica, impacto
              social y capacidad de generar oportunidades laborales sostenibles
              en agricultura, ganadería y construcción.
            </p>
            <div className="hero-buttons">
              <button
                className="btn btn-primary"
                onClick={() => setIsContactModalOpen(true)}
              >
                Descubre Más
              </button>
            </div>
          </div>
          <div className="hero-image">
            <div className="floating-card">
              <div className="card-content">
                <img
                  src={heroImage}
                  alt="Campus Eyenga"
                  style={{
                    width: "100%",
                    height: "200px",
                    objectFit: "cover",
                    borderRadius: "10px",
                    marginBottom: "1rem",
                  }}
                />
                <h3>Campus Eyenga</h3>
                <p>Educación de excelencia</p>
                <div className="progress-bar">
                  <div className="progress-fill" style={{ width: "85%" }}></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="stats">
        <div className="container">
          <div className="stats-grid">
            {stats.map((stat, index) => (
              <div key={index} className="stat-item">
                <h3 className="stat-number">{stat.number}</h3>
                <p className="stat-label">{stat.label}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="features">
        <div className="container">
          <ScrollReveal>
            <div className="section-header">
              <h2 className="section-title">¿Por qué elegir Eyenga?</h2>
              <p className="section-subtitle">
                Descubre los pilares fundamentales que nos hacen únicos en la
                formación técnica
              </p>
            </div>
          </ScrollReveal>

          <div className="features-grid">
            {features.map((feature, index) => (
              <ScrollReveal key={index} delay={index * 100}>
                <div className="feature-card">
                  <div className="feature-icon">{feature.icon}</div>
                  <h3 className="feature-title">{feature.title}</h3>
                  <p className="feature-description">{feature.description}</p>
                </div>
              </ScrollReveal>
            ))}
          </div>
        </div>
      </section>

      {/* Gallery Section */}
      <section className="gallery">
        <div className="container">
          <ScrollReveal>
            <div className="section-header">
              <h2 className="section-title">Nuestros Campus</h2>
              <p className="section-subtitle">
                Instalaciones modernas en Congo-Brazzaville y Madrid
              </p>
            </div>
          </ScrollReveal>

          <div className="gallery-grid">
            <ScrollReveal delay={100}>
              <div className="gallery-item">
                <img
                  src={campusImage1}
                  alt="Campus Congo-Brazzaville"
                  className="gallery-image"
                />
                <div className="gallery-overlay">
                  <h3>Campus Congo-Brazzaville</h3>
                  <p>100 hectáreas de formación integral</p>
                </div>
              </div>
            </ScrollReveal>

            <ScrollReveal delay={200}>
              <div className="gallery-item">
                <img
                  src={campusImage2}
                  alt="Campus Madrid"
                  className="gallery-image"
                />
                <div className="gallery-overlay">
                  <h3>Campus Madrid</h3>
                  <p>16 hectáreas de innovación educativa</p>
                </div>
              </div>
            </ScrollReveal>

            <ScrollReveal delay={300}>
              <div className="gallery-item">
                <img
                  src={laboratorioImage}
                  alt="Laboratorios especializados"
                  className="gallery-image"
                />
                <div className="gallery-overlay">
                  <h3>Laboratorios</h3>
                  <p>Análisis de suelos y alimentos</p>
                </div>
              </div>
            </ScrollReveal>

            <ScrollReveal delay={400}>
              <div className="gallery-item">
                <img
                  src={agriculturaImage}
                  alt="Programas de agricultura"
                  className="gallery-image"
                />
                <div className="gallery-overlay">
                  <h3>Agricultura Sostenible</h3>
                  <p>Técnicas modernas y tradicionales</p>
                </div>
              </div>
            </ScrollReveal>

            <ScrollReveal delay={500}>
              <div className="gallery-item">
                <img
                  src={construccionImage}
                  alt="Construcción e ingeniería"
                  className="gallery-image"
                />
                <div className="gallery-overlay">
                  <h3>Construcción</h3>
                  <p>Ingeniería civil sostenible</p>
                </div>
              </div>
            </ScrollReveal>

            <ScrollReveal delay={600}>
              <div className="gallery-item">
                <img
                  src={ganaderiaImage}
                  alt="Ganadería moderna"
                  className="gallery-image"
                />
                <div className="gallery-overlay">
                  <h3>Ganadería</h3>
                  <p>Desarrollo pecuario integral</p>
                </div>
              </div>
            </ScrollReveal>
          </div>
        </div>
      </section>

      {/* About Section */}
      <section id="about" className="about">
        <div className="container">
          <ScrollReveal>
            <div className="about-content">
              <div className="about-text">
                <h2 className="section-title">Sobre Eyenga</h2>
                <p>
                  <strong>Visión:</strong> Ser la institución líder en formación
                  técnica rural y urbana en África Central y Europa, reconocida
                  por su excelencia académica, impacto social y capacidad de
                  generar oportunidades laborales sostenibles. Eyenga fusiona
                  métodos de enseñanza innovadores con el conocimiento ancestral
                  de las comunidades locales.
                </p>
                <p>
                  <strong>Misión:</strong> Ofrecemos formación especializada en
                  agricultura, ganadería y construcción, combinando educación
                  primaria, talleres prácticos, laboratorios de análisis y
                  servicios médicos básicos para asegurar inserción laboral
                  inmediata y dinamizar las economías locales.
                </p>
                <div className="about-features">
                  <div className="about-feature">
                    <span className="check-icon">✓</span>
                    Formación práctica en 100 hectareas de campus
                  </div>
                  <div className="about-feature">
                    <span className="check-icon">✓</span>
                    Alineación con Objetivos de Desarrollo Sostenible
                  </div>
                  <div className="about-feature">
                    <span className="check-icon">✓</span>
                    Programa de becas e inclusión social
                  </div>
                  <div className="about-feature">
                    <span className="check-icon">✓</span>
                    Laboratorio de análisis certificado
                  </div>
                </div>
              </div>
              <ScrollReveal delay={200}>
                <div className="about-image">
                  <img
                    src={facilityImage2}
                    alt="Campus Eyenga - agricultura y construcción sostenible"
                    style={{
                      width: "100%",
                      height: "400px",
                      objectFit: "cover",
                      borderRadius: "15px",
                      boxShadow: "0 15px 35px -5px rgba(22, 160, 133, 0.3)",
                    }}
                  />
                </div>
              </ScrollReveal>
            </div>
          </ScrollReveal>
        </div>
      </section>

      {/* CTA Section */}
      <section className="cta">
        <div className="container">
          <div className="cta-content">
            <h2>Únete a la Revolución Educativa</h2>
            <p>
              Forma parte del proyecto Eyenga - Invirtiendo en educación técnica
              y desarrollo sostenible
            </p>
            <div className="cta-stats">
              <div className="cta-stat">
                <strong>80M USD</strong>
                <span>&nbsp;Inversión total proyectada en 4-5 años</span>
              </div>
              <div className="cta-stat">
                <strong>4-5 años</strong>
                <span>&nbsp;Período de amortización</span>
              </div>
            </div>
            <button
              className="btn btn-primary btn-large"
              onClick={() => setIsContactModalOpen(true)}
            >
              Más Información
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer id="contact" className="footer">
        <div className="container">
          <div className="footer-content">
            <div className="footer-section">
              <div className="footer-logo">
                <img
                  src={logoIcon}
                  alt="Eyenga Logo"
                  className="logo-icon"
                  style={{
                    width: "28px",
                    height: "28px",
                    borderRadius: "50%",
                    objectFit: "cover",
                  }}
                />
                <span className="logo-text">Eyenga</span>
              </div>
              <p>
                Formación técnica integral para un futuro sostenible en África
                Central y Europa.
              </p>
              <div className="project-info">
                <small>
                  Promotor: Dr. Rafael Rubio Díaz - CEO Executive Service
                  Business (España)
                </small>
                <br />
                <small>
                  Coordinador: Dr. Roland Parfait Goma (Congo-Brazzaville)
                </small>
              </div>
            </div>

            <div className="footer-section">
              <h4>Enlaces Rápidos</h4>
              <ul>
                <li>
                  <a href="#home">Inicio</a>
                </li>
                <li>
                  <a href="#features">Programas</a>
                </li>
                <li>
                  <a href="#about">Sobre Eyenga</a>
                </li>
                <li>
                  <a href="#contact">Contacto</a>
                </li>
              </ul>
            </div>

            <div className="footer-section">
              <h4>Sedes</h4>
              <p>🌍 Congo-Brazzaville (100 ha)</p>
              <p>🇪🇸 Madrid, España (16 ha)</p>
              <p>📧 info@eyenga-project.org</p>
            </div>

            <div className="footer-section">
              <h4>Áreas de Formación</h4>
              <div className="training-areas">
                <span>🌾 Agricultura</span>
                <span>🐄 Ganadería</span>
                <span>🏗️ Construcción</span>
                <span>🔬 Laboratorio</span>
              </div>
            </div>
          </div>

          <div className="footer-bottom">
            <p>&copy; 2025 Eyenga. Todos los derechos reservados.</p>
          </div>
        </div>
      </footer>

      {/* Contact Modal */}
      <ContactModal
        isOpen={isContactModalOpen}
        onClose={() => setIsContactModalOpen(false)}
      />

      {/* Scroll Arrows */}
      {/* Scroll Up Arrow */}
      {showUpArrow && (
        <button
          className="scroll-arrow scroll-arrow-up"
          onClick={handleScrollUpClick}
          aria-label="Scroll to top"
        >
          <span className="arrow-icon">↑</span>
        </button>
      )}

      {/* Scroll Down Arrow */}
      {showDownArrow && (
        <button
          className="scroll-arrow scroll-arrow-down"
          onClick={handleScrollDownClick}
          aria-label="Scroll down"
        >
          <span className="arrow-icon">↓</span>
        </button>
      )}
    </div>
  );
}

export default App;
