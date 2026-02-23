@echo off
echo ==========================================
echo TX3 Bot - Script de Arranque
echo ==========================================

:: 1. Configura tus credenciales de Telegram aquí:
set TELEGRAM_BOT_TOKEN="TU_TELEGRAM_BOT_TOKEN"
set TELEGRAM_CHAT_ID="TU_CHAT_ID"

:: (Opcional) Contraseña para el dashboard web
set DASHBOARD_SECRET=tx3-pro-bot-secret

:: 2. Ejecutar el bot
echo 🚀 Iniciando TX3 Bot...
python main.py
pause
