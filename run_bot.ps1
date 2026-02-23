# ==========================================
# TX3 Bot - Script de Arranque
# ==========================================

# 1. Configura tus credenciales de Telegram aquí:
$env:TELEGRAM_BOT_TOKEN="TU_TELEGRAM_BOT_TOKEN"
$env:TELEGRAM_CHAT_ID="TU_CHAT_ID"

# (Opcional) Contraseña para el dashboard web
$env:DASHBOARD_SECRET="tx3-pro-bot-secret"

# 2. Ejecutar el bot
Write-Host "🚀 Iniciando TX3 Bot..." -ForegroundColor Cyan
python main.py
Read-Host -Prompt "Presiona Enter para salir..."
