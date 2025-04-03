#!/bin/bash

# Получаем количество рабочих пространств
get_workspace_count() {
    wmctrl -d | wc -l
}

# Проверяем, занято ли рабочее пространство
is_workspace_occupied() {
    workspace_id=$1
    windows=$(wmctrl -l | awk '{print $2}' | grep "^$workspace_id$")
    if [ -n "$windows" ]; then
        echo 1  # Рабочее пространство занято
    else
        echo 0  # Пустое
    fi
}

# Управляем рабочими пространствами
manage_workspaces() {
    workspaces=$(get_workspace_count)
    last_workspace=$((workspaces - 1))
    second_last_workspace=$((workspaces - 2))

    last_occupied=$(is_workspace_occupied $last_workspace)
    second_last_occupied=$(is_workspace_occupied $second_last_workspace)

    # Количество пустых рабочих пространств
    empty_count=0
    for i in $(seq 0 $((workspaces - 1))); do
        occupied=$(is_workspace_occupied $i)
        if [ "$occupied" -eq 0 ]; then
            empty_count=$((empty_count + 1))
        fi
    done

    echo "Рабочих пространств: $workspaces"
    echo "Пустых рабочих пространств: $empty_count"

    # Создаём новое рабочее пространство, только если ВСЕ существующие заняты
    if [ "$empty_count" -eq 0 ]; then
        wmctrl -n $((workspaces + 1))  # Создаем новое рабочее пространство
        echo "Добавлено новое рабочее пространство!"
        sleep 2
    fi

    # Удаляем пустое рабочее пространство, если оно не единственное свободное
    if [ "$empty_count" -gt 1 ]; then
        for i in $(seq 0 $((workspaces - 1))); do
            occupied=$(is_workspace_occupied $i)
            if [ "$occupied" -eq 0 ]; then
                wmctrl -n $((workspaces - 1))  # Удаляем пустое рабочее пространство
                echo "Удалено пустое рабочее пространство!"
                sleep 2
                break  # Удаляем только одно пустое пространство
            fi
        done
    fi
}

# Запускаем мониторинг каждые 2 секунды
while true; do
    manage_workspaces
    sleep 2
done
