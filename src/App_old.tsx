import React, { useState, useEffect } from "react";
import "./App.css";
import ScrollReveal from "./components/ScrollReveal";
import ContactModal from "./components/ContactModal";

function App() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isContactModalOpen, setIsContactModalOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 100);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

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
      <nav className={`nav ${isScrolled ? "nav-scrolled" : ""}`}>
        <div className="nav-container">
          <div className="nav-logo">
            <span className="logo-icon">🌾</span>
            <span className="logo-text">Eyenga</span>
          </div>

          <div className={`nav-menu ${isMenuOpen ? "nav-menu-active" : ""}`}>
            <a
              href="#home"
              className="nav-link"
              onClick={() => setIsMenuOpen(false)}
            >
              Inicio
            </a>
            <a
              href="#features"
              className="nav-link"
              onClick={() => setIsMenuOpen(false)}
            >
              Programas
            </a>
            <a
              href="#about"
              className="nav-link"
              onClick={() => setIsMenuOpen(false)}
            >
              Nosotros
            </a>
            <a
              href="#contact"
              className="nav-link"
              onClick={() => setIsMenuOpen(false)}
            >
              Contacto
            </a>
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
              <button
                className="btn btn-secondary"
                onClick={() => setIsContactModalOpen(true)}
              >
                Contactar
              </button>
            </div>
          </div>
          <div className="hero-image">
            <div className="floating-card">
              <div className="card-content">
                <div className="card-icon">🏛️</div>
                <h3>Campus Activo</h3>
                <p>Formación integral</p>
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
                    Formación práctica en 100 ha de campus
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
                    src="/src/assets/image005.png"
                    alt="Campus Eyenga - agricultura y construcción sostenible"
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
                <span>Inversión total proyectada</span>
              </div>
              <div className="cta-stat">
                <strong>4-5 años</strong>
                <span>Período de amortización</span>
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
                <span className="logo-icon">🌾</span>
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
    </div>
  );
}

export default App;
