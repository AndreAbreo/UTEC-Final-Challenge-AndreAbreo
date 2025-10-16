#!/bin/bash
set -e

# --- CONFIGURACIÓN ---
JTL_FILE="./jmeter/results.jtl"    # ruta desde raíz del repo
THRESHOLD_P50=500                  # SLA (p50)
THRESHOLD_P95=1000                 # SLO (p95)

echo "📊 Validando SLA/SLO globales sobre $JTL_FILE ..."
if [ ! -f "$JTL_FILE" ]; then
  echo "❌ No se encontró el archivo $JTL_FILE"
  exit 1
fi

# Detectar si el archivo tiene cabecera CSV o XML
FIRST_LINE=$(head -n 1 "$JTL_FILE")
if [[ "$FIRST_LINE" =~ "<" ]]; then
  echo "⚙️ El archivo parece XML, convirtiendo a lista de tiempos..."
  TIMES=$(grep -oP '(?<=t=")[0-9]+' "$JTL_FILE" | sort -n)
else
  echo "⚙️ Archivo CSV detectado, extrayendo columna de tiempos..."
  # busca la columna de tiempo (2da o 1ra según formato)
  TIMES=$(awk -F',' '{if(NR>1) print $2}' "$JTL_FILE" | grep -E '^[0-9]+$' | sort -n)
fi

TOTAL=$(echo "$TIMES" | wc -l)
if [ "$TOTAL" -eq 0 ]; then
  echo "❌ No se encontraron tiempos válidos en el JTL."
  exit 1
fi

# Calcular percentiles
P50_INDEX=$(echo "$TOTAL*0.5" | bc -l | awk '{printf("%d",$1)}')
P95_INDEX=$(echo "$TOTAL*0.95" | bc -l | awk '{printf("%d",$1)}')
P50=$(echo "$TIMES" | sed -n "${P50_INDEX}p")
P95=$(echo "$TIMES" | sed -n "${P95_INDEX}p")

echo "----------------------------------------"
echo "🔹 P50 (median) = ${P50} ms"
echo "🔹 P95 (Line 95.0) = ${P95} ms"
echo "🔹 Umbrales: P50 ≤ ${THRESHOLD_P50} / P95 ≤ ${THRESHOLD_P95}"
echo "----------------------------------------"

# Evaluar resultados
STATUS=0

if [ "$P50" -gt "$THRESHOLD_P50" ]; then
  echo "⚠️  SLA violado: P50 (${P50} ms) > ${THRESHOLD_P50} ms"
  STATUS=1
fi

if [ "$P95" -gt "$THRESHOLD_P95" ]; then
  echo "❌ SLO violado: P95 (${P95} ms) > ${THRESHOLD_P95} ms"
  STATUS=1
fi

if [ "$STATUS" -eq 0 ]; then
  echo "✅ SLA/SLO cumplidos globalmente."
else
  echo "⛔ Pipeline detenido por violación de SLA/SLO."
fi

exit $STATUS
