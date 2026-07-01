# Imagen común para master, workers y driver.
# Partimos de la imagen OFICIAL de Apache Spark (Docker Official Image),
# que incluye PySpark. NO usamos bitnami/spark: desde 2025 esas imágenes
# dejaron de estar disponibles gratis en Docker Hub (repo movido a bitnamilegacy).
#
# Tag fijado a 3.5.8 (Scala 2.12, Java 11, Python 3) para reproducibilidad
# entre ediciones del curso. Ver otros tags: https://hub.docker.com/_/spark
FROM spark:3.5.8-scala2.12-java11-python3-ubuntu

USER root

# pip ya viene en el tag "-python3", pero aseguramos e instalamos librerías.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends python3-pip; \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Dejar 'import pyspark' funcionando en cualquier Python del contenedor
# (el driver ejecuta notebooks con un kernel Python normal, no vía spark-submit).
# Enlazamos el zip de py4j de forma independiente de la versión.
RUN ln -sf "$(ls /opt/spark/python/lib/py4j-*-src.zip)" /opt/spark/python/lib/py4j-src.zip

ENV PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-src.zip \
    PYSPARK_PYTHON=python3 \
    PYSPARK_DRIVER_PYTHON=python3

# master y workers correrán como el usuario 'spark' (no root).
# El driver se sobreescribe a root desde devcontainer.json (para escribir en /workspace).
USER spark
