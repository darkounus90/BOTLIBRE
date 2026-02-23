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

## 🧠 Flujo de la Operación Automatizada

El bot actúa bajo un modelo de **Filtros Sucesivos (Pipeline de Decisión)**:

### 1. El Generador Inicial
Constantemente el bot escucha el mercado a través de **MetaTrader 5**. Generará una señal (Buy/Sell) ya sea por cruces base de medias móviles o, idealmente, empleando el modelo predictivo de IA (**Random Forest ML**) entrenado localmente.

### 2. Los Escudos Protectores
Antes de que una orden nazca, pasa por anillos de defensa:
* **Filtro de Sesión**: Determina si los mercados base de la divisa elegida están abiertos y con suficiente liquidez institucional.
* **Escudo de Noticias (FinBERT)**: Se conecta a la IA de HuggingFace leyendo los feeds financieros para cancelar trades en momentos de alta volatilidad impredecible.
* **Escudo de Correlación**: Evita operar múltiples pares de divisas si sus gráficos marchan entrelazados (para no doblegar el riesgo o exponer demasiado margen localmente).

### 3. Escáner Avanzado (Smart Money Concepts)
Verifica la señal generada con la liquidez institucional leyendo el historial profundo del gráfico en busca de:
* Zonas de Order Block.
* Gaps (Imbalances o FVG). 
(Solo operará si hay contexto institucional apoyando la dirección del Trade).

### 4. Oráculo Juez Supremo (Gemini AI)
La señal pre-aprobada se arma con metadatos y se envía a la nube de Google (Gemini) actuando como el Oficial Principal de Negociaciones (CIO). Esta inteligencia artificial generativa evalúa factores macro, técnicos adjuntos y da un dictamen probabilístico (Confidence %) con razones verbales de peso o, de considerarlo espurio, declina la orden de tajo. 

### 5. Position Sizing (Kelly Criterion Dinámico)
Por último, el tamaño de los Lotes que el bot inyectará a la plataforma ya no es aleatorio ni fijo. Una vez Gemini nos entrega su Nivel de Confianza Probabilístico del Trade (ej. `65% de chances de rebotar`), el motor matemático calcula qué porcentaje *estricto* del saldo arriesgar mediante el método **Kelly Fractional**. 

### 6. Ejecución y Post-Operativa
Luego de colocada la operación se envían alertas de Telegram y bitácoras (Trade Journaling).  
Mientras las operaciones están abiertas, el sistema re-escanea buscando aplicar *Trailing Stops* y monitoreando el Drawdown. Si se alcanza un cierre de emergencia, el bot aplanará la mesa y detendrá la operativa el resto del día para salvaguardar el balance.
