#!/usr/bin/env bash
# ПР-2, вариант B. Таблица «модуль → число сообщений» заданного уровня по убыванию.
# Запуск: ./report.sh <каталог> <ERROR|WARN> [--top N]

usage() {
    cat >&2 <<'EOF'
Использование: ./report.sh <каталог> <ERROR|WARN> [--top N]
  <каталог>     каталог с журналами *.log
  <ERROR|WARN>  уровень сообщений
  --top N       показать только N первых модулей (N — целое число > 0)
Пример: ./report.sh data ERROR --top 3
EOF
    exit 1
}

error() {
    echo "Ошибка: $1" >&2
    usage
}

# Аргументов должно быть 2 (каталог, уровень) или 4 (плюс --top N)
if [ $# -ne 2 ] && [ $# -ne 4 ]; then
    usage
fi

dir=$1
level=$2
top=0

case $level in
    ERROR | WARN) ;;
    *) error "неверный уровень '$level' (нужно ERROR или WARN)" ;;
esac

if [ $# -eq 4 ]; then
    [ "$3" = "--top" ] || error "неизвестный параметр '$3'"
    [[ $4 =~ ^[1-9][0-9]*$ ]] || error "N должно быть целым числом > 0, получено '$4'"
    top=$4
fi

[ -d "$dir" ] || error "каталог '$dir' не существует"

shopt -s nullglob
files=("$dir"/*.log)
[ ${#files[@]} -gt 0 ] || error "в каталоге '$dir' нет файлов *.log"

# $3 — уровень, $4 — module=имя. Считаем сообщения по модулям.
printf "%-8s %5s\n" "MODULE" "COUNT"
awk -v lvl="$level" '$3 == lvl { sub(/^module=/, "", $4); count[$4]++ }
    END { for (m in count) print count[m], m }' "${files[@]}" |
    sort -k1,1nr -k2,2 |
    { if [ "$top" -gt 0 ]; then head -n "$top"; else cat; fi; } |
    awk '{ printf "%-8s %5d\n", $2, $1 }'