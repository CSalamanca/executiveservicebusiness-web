import React from "react";
import "./App.css";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>🏢 Web Corporativa</h1>
        <p>Sitio web corporativo en desarrollo</p>
        <p>
          Dominio: <strong>corporativa.local</strong>
        </p>
        <div style={{ marginTop: "2rem" }}>
          <h2>🚀 Estado del Proyecto</h2>
          <ul style={{ textAlign: "left", maxWidth: "300px" }}>
            <li>✅ DevContainer configurado</li>
            <li>✅ React App creada</li>
            <li>✅ Puerto 3000 asignado</li>
            <li>⏳ Diseño responsive pendiente</li>
          </ul>
        </div>
      </header>
    </div>
  );
}

export default App;
