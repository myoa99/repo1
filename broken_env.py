import sys

try:
    # Имитация проверки необходимых модулей
    import numpy
    print("[TEST] Библиотека numpy успешно импортирована.")
    print(f"[TEST] Версия Python: {sys.version.split(' ')[0]}")
    sys.exit(0)
except ImportError as e:
    print(f"[TEST ERROR] Отсутствует необходимая библиотека: {e}")
    sys.exit(1)
except Exception as e:
    print(f"[TEST ERROR] Неизвестная ошибка: {e}")
    sys.exit(1)
