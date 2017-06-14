#!/bin/bash
# Перекодирует рекурсивно в текущем каталоге имена
# файлов и каталогов в транслит.
SCRIPT=`readlink -e $0`
for NAME in *
  do
    LAT="$(echo $NAME | sed y/абвгдеёзийклмнопрстуфхцы/abvgdeezijklmnoprstufxcy/)"
    LAT="$(echo $LAT | sed y/АБВГДЕЁЗИЙКЛМНОПРСТУФХЦЫ/ABVGDEEZIJKLMNOPRSTUFXCY/)"
    LAT="$(echo $LAT | sed s/ч/ch/g)"
    LAT="$(echo $LAT | sed s/Ч/CH/g)"
    LAT="$(echo $LAT | sed s/ш/sh/g)"
    LAT="$(echo $LAT | sed s/Ш/SH/g)"
    LAT="$(echo $LAT | sed s/ж/zh/g)"
    LAT="$(echo $LAT | sed s/Ж/ZH/g)"
    LAT="$(echo $LAT | sed s/щ/sh\'/g)"
    LAT="$(echo $LAT | sed s/Щ/SH\'/g)"
    LAT="$(echo $LAT | sed s/э/je/g)"
    LAT="$(echo $LAT | sed s/Э/JE/g)"
    LAT="$(echo $LAT | sed s/ю/ju/g)"
    LAT="$(echo $LAT | sed s/Ю/JU/g)"
    LAT="$(echo $LAT | sed s/я/ja/g)"
    LAT="$(echo $LAT | sed s/Я/JA/g)"
    LAT="$(echo $LAT | sed s/ъ/\`/g)"
    LAT="$(echo $LAT | sed s/Ъ/\`/g)"
    LAT="$(echo $LAT | sed s/ь/\'/g)"
    LAT="$(echo $LAT | sed s/Ь/\'/g)"
    # Заменить символ пробела на символ подчёркивания
    LAT="$(echo $LAT | sed s/\\s/_/g)"
    LAT="$(echo $LAT | sed s/_-_/-/g)"
if [[ `file -b "$NAME"` == directory ]]
  then
    mv -v "$NAME" "$LAT"
    cd "$LAT"
    bash "$SCRIPT"
    cd ..
  else
    mv -v "$NAME" "$LAT"
fi
done