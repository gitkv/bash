#!/bin/bash

clear

echo "==================================================="

MASTER_DIR="/home/bitrix/www"
SANDBOX_DIR="/home/bitrix/ext_www/volkov.asiatest.ru"

# массив исключений, 
# то есть симлинки будут созданы не на них, а на все файлы внутри этих каталогов
IGNORE[0]="components"
IGNORE[1]="php_interface"
IGNORE[2]="templates"
IGNORE[3]="modules"

COUNT=0

function myln(){
	let "COUNT += 1"
	echo "СИМЛИНК СОЗДАН $2 => $1"
	ln -s $1 $2
}

function addSymlink(){
	if ! [ -e $MASTER_DIR/$1/$2 ];
	then
		echo "$MASTER_DIR/$1/$2 СИМЛИНК НЕ СОЗДАН, НЕТ ТАКОГО ФАЙЛА"
	else
		if ! [ -e $SANDBOX_DIR/$1/$2 ];
		then
			myln ${MASTER_DIR}/${1}/${2} ${SANDBOX_DIR}/${1}/${2}
		else
			echo "$MASTER_DIR/$1/$2 СИМЛИНК НЕ СОЗДАН, В КАТАЛОГЕ НАЗНАЧЕНИЯ УЖЕ ЕСТЬ ТАКОЙ ФАЙЛ"
		fi
	fi
}

function checkIgnore(){
	ignore='n'
	for ((i=0; i<=${#IGNORE[*]}; i++));
	do
		if [[ "$1" = "${IGNORE[i]}" ]]
		then
			ignore='y'
			break
		fi
	done
}

function createSymlink(){
	cd ${MASTER_DIR}/$1/
	for file in ./*;
	do
		file=${file:2} 

		checkIgnore "$file"
		if [[ "$ignore" = "y" ]]
		then
			echo "$MASTER_DIR/$1/${file} СИМЛИНК НЕ СОЗДАН, ФАЙЛ В СПИСКЕ ИСКЛЮЧЕНИЙ";
			continue
		fi

		addSymlink ${1} ${file}
	done
}


# СОЗДАНИЕ СИМЛИНКОВ
myln $MASTER_DIR/bitrix $SANDBOX_DIR/bitrix
myln $MASTER_DIR/upload $SANDBOX_DIR/upload
createSymlink "bitrix"
createSymlink "bitrix/components"
createSymlink "bitrix/php_interface"
createSymlink "bitrix/templates"
createSymlink "bitrix/modules"

echo ""
echo "ВСЕГО СИМЛИНКОВ СОЗДАНО: $COUNT"

# createSymlink "bitrix"
# for ((i=0; i<=${#IGNORE[*]}; i++));
# do
# 	createSymlink "bitrix/${IGNORE[i]}"
# done