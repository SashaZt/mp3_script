#!/bin/bash
#Обновление youtube
youtube-dl -U
#Копируем плейл лист в директорию скрипта
scp -P 22222 admin@10.0.0.2:/share/CACHEDEV1_DATA/VM/youtube/YouTube/playlist_mp3.txt /home/Sync/mp3_script/playlist.txt
# устанавливаем переменные
date="$(date +%d%m%Y)"
dir=/home/Sync/mp3_script
mix=/share/CACHEDEV1_DATA/Music/Mix
sborka=/share/CACHEDEV1_DATA/Music/Sborka
pl=/share/CACHEDEV1_DATA/VM/youtube/YouTube

#переменные для закачки
you="--extract-audio"
tub="--audio-format mp3"
t="--audio-quality 0"
#списки
pl="playlist.txt"
hs="history.txt"
rs="result.txt"
tm="temp.txt"


# Создаем копию истории и плейлиста
cp /home/Sync/mp3_script/history.txt /home/Sync/mp3_script/history_$date.txt
cp /home/Sync/mp3_script/playlist.txt /home/Sync/mp3_script/playlist_$date.txt
echo "Создана копия истории и плейлиста"


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

echo "Копируем файлы на Qnap"
find $dir -name '*.mp3' -size +102400k -exec scp -P 22222 '{}' admin@10.0.0.2:$mix \;
find $dir -name '*.mp3' -size -30720k -exec scp -P 22222 '{}' admin@10.0.0.2:$sborka \;

#Загружаем пустой список на Qnap
echo "Пустой лист отправили на Qnap"
scp -P 22222 /home/Sync/mp3_script/playlist.txt admin@10.0.0.2:/share/CACHEDEV1_DATA/VM/youtube/YouTube/playlist_mp3.txt

#Удаляем все mp3 записи
find /home/Sync/mp3_script -name '*.mp3' -exec rm -f {} \;
echo "Файлы mp3 удалены"







