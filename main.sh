#!/bin/bash
# rad-li@ya.ru
# Скрипт распознавния речи на баше
# Для записи аудио используется утилита rec из пакета SOX
# Для запуска: sh main.sh

# необходимо получить api-ключ в кабинете разработчика https://developer.tech.yandex.ru
api_key="your-api-key"

echo "Запись звука..."

# записываем звук с микрофона в файл speech.wav
# через 2 секунды тишины, запись остановится
# тишина определяется индивидуально для каждого микрофона и обстановки
# при необходимости поменяйте значение 3,8% свое
rec -r 16k -e signed-integer -b 16 -c 1 speech.wav silence 0 1 00:02 3.8%

echo "Отправляем запись на распознавание..."

# отправляем аудиофайл на сервис распознавания яндекса
# полученный ответ в xml формате записываем в файл answer.txt
wget -q --post-file speech.wav --header="Content-Type: audio/x-wav" -O - "https://asr.yandex.net/asr_xml?key=$api_key&uuid=12345678123456781234567812345678&topic=queries&lang=ru-$" > answer.txt

# с помощью awk получаем строку с распознанным текстом
awk 'BEGIN{RS="[[:space:]]*</?recognitionResults success=\"1\">[[:space:]]*";FS="[[:space:]]*<variant confidence=\"|\">|</variant>\n+"} /variant/{print $3;}' answer.txt > text.txt

# печатаем распознанный текст
cat text.txt

# удаляем временные файлы
rm answer.txt
rm text.txt