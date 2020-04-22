#!/bin/bash
dir=/home/Sync/mp3_script
mix=/share/CACHEDEV1_DATA/Music/Mix
sborka=/share/CACHEDEV1_DATA/Music/Sborka
pl=/share/CACHEDEV1_DATA/VM/youtube/YouTube
find $dir -name '*.mp3' -size +102400k -exec scp -P 22222 '{}' admin@10.0.0.2:$mix \;
find $dir -name '*.mp3' -size -30720k -exec scp -P 22222 '{}' admin@10.0.0.2:$sborka \;
scp -P 22222 /home/Sync/mp3_script/playlist.txt admin@10.0.0.2:/share/CACHEDEV1_DATA/VM/youtube/YouTube/playlist_mp3.txt
find /home/Sync/mp3_script -name '*.mp3' -exec rm -f {} \;
