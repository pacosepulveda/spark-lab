# Demostración 1 · Primeros pasos con DataFrames en Spark

## Contexto empresarial

Trabajas en el departamento de Analítica de Datos de **RetailAnalytics S.A.**, una
cadena de tiendas con presencia en 8 ciudades españolas. El equipo de dirección
quiere un primer vistazo a los datos de ventas del primer semestre de 2025 antes
de pedir análisis más profundos.

Te han pasado el archivo `ventas_retail.csv` con el detalle de cada venta
registrada en las tiendas físicas.

## Dataset

**Archivo:** `data/ventas_retail.csv` (~12.000 filas)

| Columna | Tipo | Descripción |
|---|---|---|
| `fecha` | string (YYYY-MM-DD) | Fecha de la venta |
| `tienda_id` | int | Identificador de tienda (1-8) |
| `ciudad` | string | Ciudad de la tienda |
| `categoria` | string | Categoría del producto |
| `producto` | string | Nombre del producto |
| `unidades` | int | Unidades vendidas en la transacción |
| `precio_unitario` | double | Precio por unidad (€) |
| `descuento` | double | Descuento aplicado (0, 0.1, 0.15, 0.2) |
| `cliente_id` | int | Identificador del cliente |
| `edad_cliente` | double | Edad del cliente (puede contener nulos) |
| `metodo_pago` | string | Tarjeta / Efectivo / Bizum / PayPal (puede contener nulos) |

## Objetivos de la demostración

Al finalizar esta sesión guiada, sabrás:

- Crear una `SparkSession` conectada al clúster.
- Cargar un CSV como DataFrame especificando el schema.
- Inspeccionar un DataFrame: `printSchema()`, `show()`, `describe()`, `count()`.
- Seleccionar y filtrar columnas (`select`, `filter`/`where`).
- Crear columnas derivadas (`withColumn`).
- Agrupar y agregar datos (`groupBy`, `agg`).
- Ordenar resultados (`orderBy`).

## Lo que vas a ver hacer

1. Conexión al clúster y carga del CSV.
2. Exploración inicial: ¿cuántas filas y columnas tiene? ¿qué tipo de dato es cada
   columna?
3. Cálculo del importe total de cada venta (`unidades * precio_unitario * (1 - descuento)`).
4. Facturación total por ciudad, ordenada de mayor a menor.
5. Las 5 categorías más vendidas en unidades.
6. ¿Cuál es el ticket medio (importe medio por venta) por método de pago?

## Apunta mientras observas

A lo largo de la demo, anota en tu cuaderno (lo necesitarás para el ejercicio):

- ¿Qué diferencia hay entre `select` y `withColumn`?
- ¿Qué hace `.show(n, truncate=False)` y cuándo conviene usarlo?
- ¿Por qué `groupBy` casi siempre va seguido de `.agg(...)`?

## Recursos

- [Documentación oficial PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)
- [Spark SQL functions](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/functions.html)
