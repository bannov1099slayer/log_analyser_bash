#!/bin/bash

# Проверяем существует ли access.log
if [ ! -f "access.log" ]; then
    echo "Ошибка: файл access.log не найден"
    exit 1
fi

# 1. Подсчет общего количества запросов
total_requests=$(wc -l < access.log)

# 2. Подсчет уникальных IP-адресов с использованием awk
unique_ips=$(awk '{ ip_array[$1]++ } END { print length(ip_array) }' access.log)

# 3. Подсчет количества запросов по методам
method_counts=$(awk -F'"' '{ split($2, parts, " "); methods[parts[1]]++ } 
                END { for (method in methods) print method ": " methods[method] }' access.log)

# 4. Самый популярный URL
most_popular_url=$(awk -F'"' '{ split($2, parts, " "); urls[parts[2]]++ } 
                   END { max=0; max_url=""; 
                         for (url in urls) { 
                             if (urls[url] > max) { 
                                 max = urls[url]; 
                                 max_url = url 
                             } 
                         } 
                         print max_url " (" max")" }' access.log)

# 5. Создание отчета
cat > report.txt << EOF
Отчёт о логе веб-сервера
=================================

Общее количество запросов: $total_requests
Количество уникальных IP-адресов: $unique_ips

Запросы по методам:
$method_counts

Самый популярный URL: $most_popular_url

=================================
EOF

echo "Отчет сгенерирован в файле report.txt"