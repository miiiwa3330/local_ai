@echo off
chcp 65001 > nul
echo ====================================================
echo        ローカルAI チャット起動スクリプト
echo ====================================================
echo.

:: Ollamaプロセスの確認
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] Ollama サービスは既に稼働しています。
) else (
    echo [INFO] Ollama サービスを起動しています...
    start "" "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" serve
    timeout /t 2 /nobreak > nul
)

echo [INFO] ブラウザでローカルAIチャット画面を開きます...
start "" "%~dp0chat-ui\index.html"

echo.
echo 準備完了！ブラウザの画面からチャットを開始できます。
echo （このウィンドウは数秒後に自動で閉じます）
timeout /t 3 > nul
exit

