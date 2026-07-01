# Clúster Apache Spark en GitHub Codespaces

Clúster **Spark standalone** (1 master + 2 workers) que cada alumno arranca en su
propio **Codespace**, sin instalar nada, para ejecutar algoritmos, procesar datos
y entrenar modelos de ML en notebooks Jupyter.

- **Coste:** ~0 € — cada alumno usa su cuenta gratuita de GitHub.
- **Arranque:** un clic → clúster + notebooks en ~2-3 min.
- **Clúster real** (master + workers), no `local[*]`.

---

## Para el alumno

1. Entra en el repositorio del curso en GitHub.
2. Botón verde **`< > Code`** → pestaña **Codespaces** → **Create codespace on main**.
3. Espera a que se construya el entorno (la primera vez tarda ~2-3 min: descarga y
   monta las imágenes de Spark).
4. Cuando se abra VS Code, ve a `notebooks/` y abre **`00_verificar_cluster.ipynb`**.
5. Ejecuta las celdas (▶). Si pregunta por el *kernel*, elige **Python 3**.
6. Los paneles del clúster están en la pestaña **PORTS** (abajo):
   - **Spark Master UI** (8080): verás los 2 workers.
   - **Spark App UI** (4040): aparece al lanzar un trabajo.

Cuando termines, **para el Codespace** para no consumir horas:
`Ctrl/Cmd+Shift+P` → *Codespaces: Stop Current Codespace*.

> El *free tier* de GitHub Codespaces incluye horas de núcleo gratuitas al mes.
> Una máquina de 2 núcleos durante 6 h consume 12 horas-núcleo, que caben de sobra.

---

## Estructura del proyecto

```
.
├── .devcontainer/
│   └── devcontainer.json     # Conecta VS Code al servicio "spark-driver"
├── docker-compose.yml        # master + 2 workers + driver
├── Dockerfile                # Imagen común (Spark oficial + librerías Python)
├── requirements.txt          # numpy, pandas, scikit-learn, jupyter, ...
├── notebooks/
│   ├── 00_verificar_cluster.ipynb
│   └── 01_ml_spark.ipynb
├── data/                     # Datos del alumno (vacío por defecto)
└── README.md
```

---

## Cómo funciona (para el instructor)

- **Imagen base:** imagen **oficial de Apache Spark** (`spark:3.5.8-...-python3`),
  que ya incluye PySpark. **No** se usa `bitnami/spark`: desde ago–sep 2025 esas
  imágenes se movieron a `bitnamilegacy` y dejaron de estar disponibles gratis en
  el catálogo principal de Docker Hub (romperían el `docker compose up`).
- **Una sola imagen** (`spark-lab`) para master, workers y driver → misma versión
  de Spark y de Python en todas partes (evita el error típico de *"Python in worker
  has different version than in driver"*).
- **Driver = notebook.** VS Code se conecta al contenedor `spark-driver`; el kernel
  de Jupyter es el driver Spark. Se conecta al master vía
  `spark://spark-master:7077`. La clave de red es:
  `spark.driver.host=spark-driver` + `spark.driver.bindAddress=0.0.0.0`,
  para que los executors puedan devolver resultados al driver.
- **Recursos:** cada worker se limita a 1 núcleo y 1.5 GB, adecuado para la máquina
  por defecto de Codespaces (2 núcleos / 8 GB).

### Ajustes útiles

- **Más potencia:** si un ejercicio necesita más, cambia la máquina del Codespace
  a 4 núcleos (`Codespaces: Change Machine Type`). 6 h × 4 núcleos = 24 h-núcleo.
- **Más/menos workers:** duplica o elimina bloques `spark-worker-N` en
  `docker-compose.yml` (recuerda ajustar `spark.cores.max` en los notebooks).
- **Fijar versiones de librerías:** añade `==x.y.z` en `requirements.txt` para
  reproducibilidad total entre ediciones.
- **Otra versión de Spark:** cambia el tag en `Dockerfile`
  (lista de tags: https://hub.docker.com/_/spark). Se recomienda 3.5.x por
  compatibilidad; Spark 4.x activa ANSI SQL por defecto y puede romper ejemplos.

### Datos del curso

Deja datasets en `data/` (o que los alumnos los suban ahí). Están disponibles en
`/workspace/data` dentro del contenedor. Para datasets grandes/compartidos, es mejor
que los notebooks los descarguen de una URL en la primera celda.

---

## Solución de problemas

| Síntoma | Causa / solución |
|---|---|
| `ErrImagePull` / no arranca | Revisa que el tag de Spark del `Dockerfile` existe en Docker Hub. |
| El notebook no encuentra el kernel | Elige el intérprete `/usr/bin/python3`. |
| `Initial job has not accepted any resources` | Los workers aún no se registraron o `cores.max`/`executor.memory` piden más de lo disponible. Espera 10-15 s y reintenta, o baja los valores. |
| No aparece la Master UI | Pestaña **PORTS** → abre el 8080. Puede tardar unos segundos en levantar. |
| Se acaban las horas gratis | Para el Codespace al terminar; usa máquina de 2 núcleos. |
