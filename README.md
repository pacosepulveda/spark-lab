# Clúster Spark para clase (vía GitHub Codespaces)

Cada alumno levanta su propio clúster Spark (1 master + 2 workers) + Jupyter,
sin instalar nada, con un clic.

## Qué incluye

- `docker-compose.yml` → 1 spark-master, 2 spark-worker, 1 contenedor Jupyter
  con PySpark + scikit-learn + pandas + matplotlib + mlflow.
- `.devcontainer/devcontainer.json` → hace que Codespaces levante todo
  automáticamente al abrir el repo (usa el servicio `jupyter` como contenedor
  de trabajo).
- `notebooks/00_bienvenida.ipynb` → notebook de comprobación: conecta al
  clúster, genera datos, entrena un modelo de ML distribuido con MLlib.
- `data/` → carpeta para datasets de la clase.

## Setup (tú, antes de la clase)

1. Crea un repositorio en GitHub (puede ser privado o público) y sube esta
   carpeta tal cual.
2. Configúralo como **Template repository**:
   `Settings → General → Template repository` (marca la casilla).
   Así cada alumno puede generar su propia copia con un clic en
   "Use this template" en lugar de hacer fork (evita líos de permisos).
3. Prueba tú mismo: abre el repo → botón verde **Code → Codespaces →
   Create codespace on main**. Espera ~2-3 min. Verifica:
   - Notebook arranca solo (gracias a `postStartCommand`).
   - Puerto 8080 (Spark Master UI) muestra 2 workers conectados.
   - Ejecuta `00_bienvenida.ipynb` de principio a fin sin errores.
4. Comparte con los alumnos el link del repo y este mensaje:

> 1. Entra en el repo: [LINK]
> 2. Botón verde **"Use this template" → "Create a new repository"**
>    (o "Open in a codespace" si lo dejas como repo normal).
> 3. Luego **Code → Codespaces → Create codespace on main**.
> 4. Espera 2-3 minutos.
> 5. **IMPORTANTE**: NO abras el `.ipynb` directamente en el editor de VS Code.
>    Ve a la pestaña **PUERTOS** (junto a TERMINAL) y haz clic en el icono del
>    globo terráneo junto al puerto **8888** — se abrirá el Jupyter clásico en
>    una pestaña nueva del navegador. Ahí sí abres `notebooks/00_bienvenida.ipynb`
>    y ejecutas las celdas con normalidad.

## Troubleshooting

### "Escriba la dirección URL del servidor de Jupyter en ejecución"

Este mensaje aparece si abres el `.ipynb` con el editor nativo de VS Code
(extensión Jupyter) en vez de con el Jupyter clásico del navegador. Motivo: por
defecto, Codespaces sobreescribe el `command:` del contenedor con `sleep infinity`,
así que el servidor Jupyter nunca llega a arrancar. Esto ya está corregido en
`devcontainer.json` con `"overrideCommand": false` — si sigues viendo el problema:

1. **Reconstruye el Codespace**: `Ctrl+Shift+P` → `Codespaces: Rebuild Container`.
2. Comprueba el log de build: `Ctrl+Shift+P` → `Codespaces: View Creation Log`.
   Busca errores en el `docker compose build` del servicio `jupyter`.
3. Sigue siempre el flujo de la pestaña **PUERTOS** → puerto 8888 → abrir en
   navegador, nunca el editor de notebooks integrado en VS Code.

### No se ve nada en el puerto 8080 (Spark Master UI)

Casi siempre es síntoma de que el `docker compose up` no llegó a completar
(los 4 contenedores: master, 2 workers, jupyter). Revisa el creation log
(paso 2 de arriba). Si el build del `Dockerfile.jupyter` está tardando mucho
(instala scikit-learn, mlflow, etc.), sube la máquina del Codespace a 4 núcleos
al crearlo — con 2 núcleos el build de 4 contenedores en paralelo puede agotar
el tiempo de espera.

### Los alumnos ven "detectando kernels" indefinidamente

Confirma que están en la URL del puerto 8888 (Jupyter clásico), no en el
notebook abierto dentro de VS Code. El Jupyter clásico no depende de la
extensión Python/Jupyter de VS Code en absoluto.

## Notas importantes

- **Free tier de Codespaces**: 60 core-hours/mes y 15 GB de storage por
  cuenta gratuita de GitHub. Una sesión de 6h en máquina de 2 núcleos = 12
  core-hours → sobra margen, pero si la clase se repite varias veces al mes
  conviene avisar a los alumnos.
- **Tamaño de máquina**: por defecto Codespaces asigna 2 núcleos / 8GB RAM,
  suficiente para 1 master + 2 workers de 1GB. Si vas a procesar datasets
  grandes, sube la machine type a 4 núcleos en el selector al crear el
  codespace (consume más core-hours).
- **Aislamiento**: cada alumno tiene su codespace y su clúster propio, nadie
  comparte recursos ni puede ver el trabajo de otro.
- **Apagar al terminar**: los Codespaces se detienen solos tras 30 min de
  inactividad, pero conviene pedir a los alumnos que hagan
  `Codespaces → Stop codespace` al acabar la sesión para no gastar cuota.
- **Persistencia**: si paras (no borras) el codespace, los notebooks y
  cambios se conservan para la siguiente sesión (hasta que expira por
  inactividad prolongada, ~30 días).

## Ampliar el cluster o los datos

- Para añadir más workers: duplica el bloque `spark-worker-2` en
  `docker-compose.yml` con otro nombre de servicio.
- Para añadir datasets: colócalos en `data/`, se montan automáticamente en
  `/home/jovyan/data` dentro de Jupyter.
- Para añadir notebooks de los módulos del curso: añádelos en `notebooks/`
  siguiendo la numeración `01_`, `02_`, etc.
