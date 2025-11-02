

<img href = "../imgs/breakdownBanner.png" width = "200">

<h1 align = "center">Breakdown</h1>

<p>
Breakdown es un videojuego desarrollado en <strong>Lenguaje Ensamblador (ASM)</strong> para el procesador <strong>Intel 8086</strong>, ejecutable en el entorno <strong>Emu8086</strong>.
El proyecto busca demostrar el funcionamiento interno de la arquitectura x86 mediante rutinas gráficas, control de flujo y manejo de interrupciones.
</p>

<hr>

<h2 align = "center">Estructura del repositorio</h2>

<pre>
Breakdown/
│
├── Codigo/
│   ├── breakdown.asm               # Código fuente principal del juego
│   ├── breakdown.exe               # Ejecutable compilado desde Emu8086
│   ├── breakdown.exe.debug         # Archivos de depuración
│   ├── breakdown.exe.list
│   ├── breakdown.exe.symbol
│   ├── breakdown.exe.~asm
│   ├── breakdown.exe_BKP*          # Copias de respaldo del ejecutable
│
├── Recursos Necesarios/
│   └── Emu8086.zip                 # Entorno necesario para ejecutar el código ASM
│
└── .gitattributes                  # Configuración de Git
</pre>

<hr>

<h2 align = "center">Descripción del juego</h2>

<p>
<strong>Breakdown</strong> es un juego de tipo <em>breakout</em>, donde el jugador controla una paleta que rebota una pelota para destruir bloques en pantalla.
Fue desarrollado con fines educativos para aplicar y reforzar conceptos de programación en ensamblador, tales como:
</p>

<ul>
  <li>Uso de interrupciones del BIOS y DOS.</li>
  <li>Manipulación de gráficos en modo texto o video.</li>
  <li>Control de eventos del teclado.</li>
  <li>Bucles, comparaciones y lógica de colisiones.</li>
</ul>

<hr>

<h2 align = "center">Ejecución del proyecto</h2>

<ol>
  <li>Descarga o clona el repositorio:
    <pre>git clone https://github.com/Benjamin-Solano/Breakdown.git</pre>
  </li>
  <li>Extrae y abre el entorno <strong>Emu8086</strong> desde la carpeta <code>Recursos Necesarios/Emu8086.zip</code>.</li>
  <li>Abre el archivo <code>Codigo/breakdown.asm</code> en el entorno <strong>Emu8086</strong>.</li>
  <li>Compila y ejecuta el programa.</li>
  <li>También puedes ejecutar directamente <code>breakdown.exe</code> si el entorno lo permite.</li>
</ol>

<hr>

<h2 align = "center">Objetivo del proyecto</h2>

<p>
El propósito principal es comprender la estructura y funcionamiento de un videojuego escrito en ensamblador, reforzando los siguientes conocimientos:
</p>

<ul>
  <li>Segmentación de memoria.</li>
  <li>Control de flujo mediante saltos y bucles.</li>
  <li>Interacción directa con el hardware.</li>
  <li>Diseño de experiencias visuales básicas sin librerías externas.</li>
</ul>

<hr>

<h2 align = "center">Créditos</h2>

<p>
Desarrollado por <strong>Benjamín Solano</strong><br>
Universidad / Curso de Programación en Ensamblador<br>
Año: 2025
</p>

<hr>

<h2 align = "center">Licencia</h2>

<p>
Este proyecto se distribuye con fines educativos y de aprendizaje.<br>
Se permite su uso, modificación y análisis sin fines comerciales.
</p>
