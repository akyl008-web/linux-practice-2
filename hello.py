#!/usr/bin/env python3
"""ПР-2, вариант B. Читает файл и печатает его размер в байтах.
Запуск: python3 hello.py <файл>"""
import sys

if len(sys.argv) != 2:
    print("Использование: python3 hello.py <файл>", file=sys.stderr)
    sys.exit(1)

with open(sys.argv[1], "rb") as f:
    data = f.read()
print(len(data))