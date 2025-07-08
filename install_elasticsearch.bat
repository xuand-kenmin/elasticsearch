@echo off
setlocal

:: ============================
:: CONFIGURATION (Sửa nếu cần)
:: ============================
set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "ES_HOME=C:\elasticsearch"

:: ============================
:: Thiết lập JAVA_HOME và PATH
:: ============================
setx JAVA_HOME "%JAVA_HOME%" /M
setx ES_HOME "%ES_HOME%" /M
setx PATH "%PATH%;%JAVA_HOME%\bin;%ES_HOME%\bin" /M
echo [✔] Đã thiết lập JAVA_HOME, ES_HOME, PATH

:: ============================
:: Cài đặt Elasticsearch Service
:: ============================
cd /d "%ES_HOME%\bin"
echo [⚙] Đang cài đặt Elasticsearch service...
elasticsearch-service.bat install

:: ============================
:: Thiết lập chế độ Delayed Auto Start
:: ============================
sc config "elasticsearch-service-x64" start= delayed-auto

:: ============================
:: Khởi động dịch vụ
:: ============================
elasticsearch-service.bat start
if %ERRORLEVEL% NEQ 0 (
    echo [✖] Không thể khởi động Elasticsearch.
    pause
    exit /b 1
)

:: ============================
:: Kiểm tra kết nối
:: ============================
echo [🌐] Chờ 10 giây để Elasticsearch khởi động...
timeout /t 10 >nul

curl http://localhost:9200
echo.
echo [✅] Elasticsearch đã được cài đặt và chạy ở chế độ Delayed Start!

pause
