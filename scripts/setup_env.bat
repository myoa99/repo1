@echo off
setlocal enabledelayedexpansion

:: Задаем имя окружения и версию Python
set ENV_NAME=my_project_env
set PYTHON_VERSION=3.10

:: Переходим в корень проекта (на одну папку вверх от скрипта)
set "PROJECT_ROOT=%~dp0.."
cd /d "%PROJECT_ROOT%"

echo === Проверка наличия Conda ===
where conda >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Conda не найдена в PATH. 
    echo Убедитесь, что Anaconda/Miniconda установлена и добавлена в PATH.
    exit /b 1
)

echo === Проверка окружения %ENV_NAME% ===
:: Ищем точное совпадение имени окружения
call conda env list | findstr /R /C:"\<%ENV_NAME%\>" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Окружение %ENV_NAME% уже существует. Пропускаем создание.
) else (
    echo [INFO] Создание окружения %ENV_NAME% с Python %PYTHON_VERSION%...
    call conda create -y -n %ENV_NAME% python=%PYTHON_VERSION%
    if !ERRORLEVEL! NEQ 0 (
        echo [ERROR] Не удалось создать окружение.
        exit /b 1
    )
)

echo === Установка зависимостей ===
if exist requirements.txt (
    echo [INFO] Установка пакетов из requirements.txt...
    call conda run -n %ENV_NAME% python -m pip install -r requirements.txt
    if !ERRORLEVEL! NEQ 0 (
        echo [ERROR] Ошибка при установке зависимостей.
        exit /b 1
    )
) else (
    echo [WARNING] Файл requirements.txt не найден в корне проекта.
)

echo === Запуск Smoke Test (broken_env.py) ===
if exist broken_env.py (
    call conda run -n %ENV_NAME% python broken_env.py
    if !ERRORLEVEL! NEQ 0 (
        echo [ERROR] Smoke test завершился с ошибкой.
        exit /b 1
    )
) else (
    echo [ERROR] Файл broken_env.py не найден.
    exit /b 1
)

echo [OK] Окружение успешно настроено и протестировано!
exit /b 0