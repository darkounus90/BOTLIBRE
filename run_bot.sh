#!/bin/bash

# ==========================================
# TX3 Bot - Script de Arranque
# ==========================================

# 1. Configura tus credenciales de Telegram aquí:
export TELEGRAM_BOT_TOKEN="TU_TELEGRAM_BOT_TOKEN"
export TELEGRAM_CHAT_ID="TU_CHAT_ID"

# (Opcional) Contraseña para el dashboard web
export DASHBOARD_SECRET="tx3-pro-bot-secret"

# 2. Ejecutar el bot
echo "🚀 Iniciando TX3 Bot..."
python main.py
