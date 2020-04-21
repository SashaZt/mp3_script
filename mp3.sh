#!/bin/bash
#Обновление youtube
youtube-dl -U
date="$(date +%d%m%Y)"
cp /home/Sync/mp3_script/history.txt /home/Sync/mp3_script/history_$date.txt
cp /home/Sync/mp3_script/playlist.txt /home/Sync/mp3_script/playlist_$date.txt
echo "Создана копия истории и плейлиста"

#переменные для закачки
you="--extract-audio"
tub="--audio-format mp3"
t="--audio-quality 0"
#списки
pl="playlist.txt"
hs="history.txt"
rs="result.txt"
tm="temp.txt"

#находим уникальные записи
comm -23 <(sort $pl) <(sort $hs)|cat > $rs

#качаем уникальные записи
for var in $(cat $rs)
do
youtube-dl $you $tub $t "$var"
done
#очищаем список
:>$pl
echo "playlist очищен"

#дописать скачанные записи
cat $rs >> $hs
echo "История дописанна"
:>$rs
echo "result очищен"
#удалить дубликаты в истории
uniq <(sort $hs) > $tm
mv $tm $hs
echo "создан новый файл истории"
