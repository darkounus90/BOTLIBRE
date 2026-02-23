# 🤖 TX3 Bot: Funcionamiento Libre (Cuenta Normal)

Este documento detalla la arquitectura operativa y el flujo del TX3 Bot tras su adaptación desde un sistema evaluativo institucional (Prop Firm) hacia un modelo libre para cuentas de trading regulares.

## 🔄 Los Cambios Arquitectónicos
1. **Paso a Cuenta Normal**: 
   Todo el motor de `PhaseTracker` (rastreador de fases), variables de "días mínimos", comprobadores de regla de consistencia y objetivos financieros (Profit Targets de 5% o 10%) han sido eliminados de raíz. 
   El script ahora fluye en un ciclo continuo sin meta de cierre de desafío. Ahora utiliza `AccountConfig` en vez de `ChallengeConfig`.

2. **Cálculo de Riesgo Dinámico**: 
   Anteriormente, los Drawdowns estaban bloqueados simulando un capital base inamovible de $50,000.  
   Ahora, el Risk Management se calibra automáticamente escaneando el Balance Real en MetaTrader al arrancar el bot, aplicando métricas racionales (ej. Max DD) sobre él.

3. **Telegram y Dashboard**: 
   Los tableros y avisos se purgaron de datos en referencia a progreso de pruebas. Presentan sólo WinRate, DD en dinero real, Equity, Trades Diarios y Logs.

---

## 🧠 El Cerebro Cuádruple: 4 Capas de Inteligencia Artificial

Lo que diferencia a este bot de un "Asesor Experto" (EA) tradicional es su **arquitectura de decisiones híbrida**. No obedece simplemente a líneas condicionales estáticas, sino que emplea una red de 4 capas distintas de IA superpuestas para tomar decisiones institucionales:

### 🤖 Capa 1: El Generador Cuantitativo (Machine Learning - Random Forest)
La base del bot está en `ml_random_forest.py`. En lugar de buscar "cruces de medias móviles", el bot entrena un modelo de ***Machine Learning (Random Forest)*** con miles de velas de datos históricos de MetaTrader.
* **Misión:** Aprender patrones no lineales ocultos del precio, volatilidad (ATR) y volumen.
* **Acción:** Predecir si la próxima dirección del mercado será favorable para una compra (BUY), venta (SELL) o mantenernos al margen (HOLD).

### 📰 Capa 2: Analista Fundamental (NLP - FinBERT HuggingFace)
En el trading institucional, los datos macroeconómicos destruyen cualquier gráfico técnico. El bot incluye a `ai_sentiment.py`.
* **Misión:** Se conecta en tiempo real a las APIs de noticias globales y lee los titulares financieros utilizando ***Procesamiento de Lenguaje Natural (FinBERT de HuggingFace)***, un modelo pre-entrenado específicamente con jerga de Wall Street.
* **Acción:** Si detecta noticias extremadamente bajistas o pánico en los mercados para la divisa operando, activa un **Killswitch (Escudo)** y bloquea instantáneamente las operaciones técnicas que vayan en su contra.

### 🧠 Capa 3: Agente de Adaptación Dinámica (Reinforcement Learning - Q-Learning)
Los mercados cambian (tendencia fuerte vs mercado lateral). Una estrategia estática siempre termina fallando cuando el régimen cambia. En `q_learning_agent.py` se aloja un cerebro de ***Aprendizaje por Refuerzo (RL)***.
* **Misión:** Observar el contexto actual (indicador ADX, fuerza de tendencia) y darle una "recompensa" o "castigo" a la estrategia base según si acertaron o fallaron recientemente.
* **Acción:** Si nota que el mercado está en un estado lateral errático, interviene la orden generada en la Capa 1 y emite un veto forzoso (HOLD) para salvaguardar tu dinero.

### ⚖️ Capa 4: Oráculo Juez Supremo (LLM Generativo - Gemini AI)
La señal pre-aprobada por el modelo de datos estadísticos (Capa 1), que pasó por el filtro de miedo del mercado (Capa 2) y que fue aprobada por el agente de adaptación (Capa 3), no se lanza al mercado directamente; antes debe pasar por la mesa del Director de Inversiones (CIO).
* **Misión:** Un ***Modelo de Lenguaje Grande (Google Gemini)*** recibe en un *Prompt Compuesto* toda la telemetría del trade: el P&L actual, las condiciones técnicas, y el razonamiento base.
* **Acción:** Gemini actúa como un humano profesional, evalúa el riesgo y escupe dos cosas vitales: un veredicto estructurado (`APPROVED` o `REJECTED`) y un **Nivel de Confianza (Confidence %)** del trade. Si lo considera una transacción basura, simplemente declina la orden de tajo. 

---

## ⚙️ Flujo de Operación (Pipeline de Decisión)

Con la Inteligencia artificial de fondo, así es el día a día real del Bot:

### 1. Detección y Escáner (Smart Money Concepts)
Constantemente el bot escucha el mercado a través de MetaTrader 5. Las 4 capas de IA inician su procesamiento al unísono. Adicionalmente, escanea el historial gráfico profundo (SMC) buscando vacíos de liquidez (Gaps/FVG) o Zonas Institucionales de Order Blocks para apoyar la entrada IA.

### 2. Dimensionamiento del Lote por IA (Position Sizing - Kelly Criterion)
Una vez **Gemini AI** nos entrega su Nivel de Confianza Probabilístico del Trade (ej. `68% de certeza`), el tamaño de los Lotes que el bot inyectará a la plataforma no será un miserable `0.01` estático ni un salvaje `1.0`. El motor matemático calcula qué porcentaje *estricto* de los dólares de tu cuenta arriesgar utilizando el modelo iterativo de apuestas **Kelly Fractional**.

### 6. Ejecución y Post-Operativa
Luego de colocada la operación se envían alertas de Telegram y bitácoras (Trade Journaling).  
Mientras las operaciones están abiertas, el sistema re-escanea buscando aplicar *Trailing Stops* y monitoreando el Drawdown. Si se alcanza un cierre de emergencia, el bot aplanará la mesa y detendrá la operativa el resto del día para salvaguardar el balance.
