# 🧩 Informe Técnico – Build Integrador 2025

**Repositorio:** [https://github.com/AndreAbreo/UTEC-Final-Challenge-AndreAbreo.git](https://github.com/AndreAbreo/UTEC-Final-Challenge-AndreAbreo.git)  
**Proyecto:** Plataforma e-Commerce –  
**Autor:** André Abreo – Equipo QA / Performance Testing  
**Fecha:** Octubre 2025  
**Herramienta:** Apache JMeter 5.6.3 + Jenkins + Docker + Grafana / Prometheus  
**Escenario:** 300 requests por tirada, 10 hilos, 30 segundos, 5 loops.  

---

## 1️⃣ Objetivo Técnico

- Ejecutar pipeline automatizado con tests de rendimiento desde **Jenkins**.  
- Validar **SLA y SLO** (P50 ≤ 500 ms, P95 ≤ 1000 ms) mediante el script `validate-sla.sh`.  
- Demostrar flujo **CI/CD** con infraestructura contenedorizada.  

---

## 2️⃣ Infraestructura y Entorno

- **VM VirtualBox:** Ubuntu 24.04 (8 GB RAM, 4 CPU).  
- **Contenedores Docker:** aplicación ShopTech, Jenkins, Prometheus, Grafana.  
- **Red Bridge:** comunicación entre host y contenedores.  
- **Plugins Jenkins:** Performance Plugin + HTML Publisher.  

---

## 3️⃣ Pipeline CI/CD

1. Clonado automático del repositorio GitHub.  
2. Build de imagen JMeter.  
3. Ejecución de tests con 300 requests, 10 hilos, 30 segundos, 5 loops.  
4. Generación de `results.jtl` + reportes HTML.  
5. Ejecución de `validate-sla.sh` → corte automático si **P50 > 500 ms** o **P95 > 1000 ms**.  
6. Publicación de resultados en Jenkins y monitoreo en Grafana.  

---

## 4️⃣ Resultados Técnicos

| Servicio / Endpoint | SLA P50 (ms) | SLA P95 (ms) | Resultado P50 (ms) | Resultado P95 (ms) | Estado |
|:--------------------|:------------:|:------------:|:------------------:|:------------------:|:------:|
| 00 - Health | ≤ | ≤ | 3 | 10 | 🟢 Cumple |
| 01 - Login | ≤ 500 | ≤ 1000 | 140 | 241 | 🟢 Cumple |
| 02 - Products | ≤ 500 | ≤ 1000 | 105 | 193 | 🟢 Cumple |
| 03 - Cart | ≤ 500 | ≤ 1000 | 148 | 249 | 🟢 Cumple |
| 04 - Checkout | ≤ 500 | ≤ 1000 | 254 | 404 | 🟢 Cumple |
| 05 - Metrics | ≤ | ≤ | 4 | 7 | 🟢 Cumple |
| **TOTAL DE LAS REQUEST** | **≤ 500** | **≤ 1000** | **111** | **348** | **🟢 Cumple** |

**Error Rate:** 0 %  
**Throughput:** 25.0 req/s  
**Disponibilidad:** 100 %

🔹 *Outliers máximos en* `/login` ≈ **2742 ms** (últimos 3 % de muestras).  
🔹 `/checkout` alcanzó máximo de **417 ms** sin impactar P95.  

---

## 5️⃣ Análisis y Ley de Little

\[
\lambda = 25 \text{ req/s},\ R = 0.348 \text{ s} \Rightarrow N = 8.7 \approx 9 \text{ usuarios efectivos por instancia.}
\]

Esto permite escalar linealmente hasta ≈ **450 usuarios simultáneos** manteniendo estabilidad.  

---

## 6️⃣ Desafíos y Aprendizajes (Anexo)

- Levantar y configurar VM Ubuntu en VirtualBox.  
- Clonar y configurar repositorio GitHub.  
- Desplegar contenedores Docker (ShopTech, Jenkins, Prometheus, Grafana).  
- Descargar plugins y configurar Jobs en Jenkins.  
- Crear plan de pruebas JMeter con EDP (login, productos, checkout, pago).  
- Desarrollar `validate-sla.sh` para corte de pipeline por SLA/SLO.  
- Adaptar y depurar pipelines locales y remotos hasta obtener builds exitosos.  
- Implementar monitoreo básico en Grafana y Prometheus para visualizar métricas en vivo.  

---

## ✅ Conclusión Técnica

El entorno y pipeline funcionan correctamente, los tests son reproducibles y los resultados cumplen los objetivos de rendimiento.  
La automatización con **Jenkins** y el monitoreo con **Grafana** brindan una base sólida para escalar las pruebas de rendimiento en futuros entornos **cloud o distribuidos**.  

---

## 📎 Anexos (Resumen Visual)

*(En esta sección se incluirán capturas de dashboards de Grafana, reportes HTML de Jenkins y resultados JMeter del build integrador.)*
