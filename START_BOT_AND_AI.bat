@echo off
echo ==========================================================
echo    🌌 TX3 PRO BOT - ARRANQUE INTELIGENTE AUTOMATIZADO
echo ==========================================================
echo.
echo [1/3] Verificando e Instalando Librerias de Inteligencia Artificial...
pip install -r requirements.txt
echo.

echo [2/3] Verificando Memoria de Machine Learning...
if not exist "data\rf_model_EURUSD.pkl" (
    echo    ! El Cerebro IA es nuevo y necesita ser entrenado por primera vez.
    echo    - Ejecutando el Scanner y Entrenador Espacial - Esto tardara 1-2 minutos...
    python scripts\train_ml_model.py
) else (
    echo    ✅ El Cerebro IA ya esta cargado y en linea.
)
echo.

:: 3. Configura tus credenciales de Telegram aquí si lo deseas (O usa entorno):
set TELEGRAM_BOT_TOKEN="TU_TELEGRAM_BOT_TOKEN"
set TELEGRAM_CHAT_ID="TU_CHAT_ID"
set DASHBOARD_SECRET="tx3-pro-bot-secret"
set HUGGINGFACE_TOKEN="TU_HUGGINGFACE_TOKEN"
set GEMINI_API_KEY="TU_GEMINI_API_KEY"

echo [3/3] 🚀 Arrancando Bot Principal...
echo ==========================================================
python main.py
pause
