#!/bin/bash
#Обновление youtube
youtube-dl -U
scp -P 22222 admin@10.0.0.2:/share/CACHEDEV1_DATA/VM/youtube/YouTube/playlist_mp3.txt /home/Sync/mp3_script/playlist.txt
date="$(date +%d%m%Y)"
cp /home/Sync/mp3_script/history.txt /home/Sync/mp3_script/history_$date.txt
cp /home/Sync/mp3_script/playlist.txt /home/Sync/mp3_script/playlist_$date.txt
dir=/home/Sync/mp3_script
mix=/share/CACHEDEV1_DATA/Music/Mix
sborka=/share/CACHEDEV1_DATA/Music/Sborka
pl=/share/CACHEDEV1_DATA/VM/youtube/YouTube

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

echo "Копируем файлы на Qnap"
find $dir -name '*.mp3' -size +102400k -exec scp -P 22222 '{}' admin@10.0.0.2:$mix \;
find $dir -name '*.mp3' -size -30720k -exec scp -P 22222 '{}' admin@10.0.0.2:$sborka \;
scp -P 22222 /home/Sync/mp3_script/playlist.txt admin@10.0.0.2:/share/CACHEDEV1_DATA/VM/youtube/YouTube/playlist_mp3.txt
find /home/Sync/mp3_script -name '*.mp3' -exec rm -f {} \;
