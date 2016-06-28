#!/usr/bin/env bash

clear


echo -e "\033[1mВведите полный путь до корня проекта на битрикс (Например /var/www/site/public/):\033[0m";
read TARGET_DIR

TIMESTAMP=`date +%Y%m%d.%H%M`

BACKUP_DIR="./ORIGINAL_${TIMESTAMP}";

mkdir $BACKUP_DIR

echo  "create backup files";
cp $TARGET_DIR/bitrix/modules/main/include/prolog_after.php $BACKUP_DIR
cp $TARGET_DIR/bitrix/modules/main/interface/prolog_main_admin.php $BACKUP_DIR
cp $TARGET_DIR/bitrix/modules/main/include.php $BACKUP_DIR
cp $TARGET_DIR/bitrix/modules/main/tools.php $BACKUP_DIR

echo  "create nulledBX";
cp ./nulled/prolog_after.php $TARGET_DIR/bitrix/modules/main/include/
cp ./nulled/prolog_main_admin.php $TARGET_DIR/bitrix/modules/main/interface/
cp ./nulled/include.php $TARGET_DIR/bitrix/modules/main/
cp ./nulled/tools.php $TARGET_DIR/bitrix/modules/main/

echo  "complete";