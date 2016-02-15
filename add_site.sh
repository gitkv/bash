#!/bin/bash

#Хуй знает как тут требовать пароль от рута, но пака выполняем это скрипт через SUDO

clear

echo -e "\033[1mВведите название проекта в домене test (Например example, получится example.test):\033[0m";
read PROJECT

DOMAIN="${PROJECT}.test"

WWW="/var/www"
SYMLINK_FOLDER="/home/gitkv/www"
FOLDER_OWN="gitkv:gitkv"
PERM="755"

#создаем каталоги
mkdir $WWW/$DOMAIN
mkdir $WWW/$DOMAIN/public/
mkdir $WWW/$DOMAIN/cgi-bin/
mkdir $WWW/$DOMAIN/logs/

#указываем владельца и права на каталоги проекта и веб-сервера
chown -R $FOLDER_OWN $WWW/$DOMAIN/
chmod -R $PERM $WWW/$DOMAIN/
chown -R $FOLDER_OWN $WWW/$DOMAIN/public/
chmod -R $PERM $WWW/$DOMAIN/public/

# Создаем стартовую страничку в public
touch $WWW/$DOMAIN/public/index.php
echo "<h2>It Works! $DOMAIN</h2><?php phpinfo(); ?>" >> $WWW/$DOMAIN/public/index.php
chown -R $FOLDER_OWN $WWW/$DOMAIN/public/index.php
chmod -R $PERM $WWW/$DOMAIN/public/index.php


# добавляем в хосты
add_to_hosts_conf="127.0.0.1 ${DOMAIN}"
echo "$add_to_hosts_conf" >> /etc/hosts 

# создаем виртуальный хост
add_to_apache_conf="
<VirtualHost *:80>
ServerName ${DOMAIN}
    ServerAlias www.${DOMAIN}
    ServerAdmin webmaster@${DOMAIN}
    DocumentRoot ${WWW}/${DOMAIN}/public
    <Directory ${WWW}/${DOMAIN}/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>

    ScriptAlias /cgi-bin/ ${WWW}/${DOMAIN}/cgi-bin/
    <Directory "${WWW}/${DOMAIN}/cgi-bin">
        AllowOverride All
        Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
        Order allow,deny
        Allow from all
    </Directory>

    ErrorLog ${WWW}/${DOMAIN}/logs/error.log
    LogLevel warn
    CustomLog ${WWW}/${DOMAIN}/logs/access.log combined
</VirtualHost>"

touch /etc/apache2/sites-available/${DOMAIN}.conf
echo "$add_to_apache_conf" > /etc/apache2/sites-available/${DOMAIN}.conf

# включаем сайт у апача
a2ensite ${DOMAIN}

#Создаем БД
echo -e "\033[1mСоздать БД (${DOMAIN}) для проекта?(yes/no)\033[0m"
read CREATE_DB
if  [ "$CREATE_DB" = "yes" -o "$CREATE_DB" = "y" -o "$CREATE_DB" = "YES"  -o "$CREATE_DB" = "Y" ]; then

	#ЕСЛИ НАДО КАСТОМНЫЕ ИМЕНА БД, ТО РАСКАММЕНТИТЬ, А НИЖНИЕ 2 СТРОКИ ЗАКАММЕНТИТЬ
	#echo -e "\033[1mВведите имя базы данных для сайта ${DOMAIN}:\033[0m";
	#read DB_NAME
	DB_NAME="${PROJECT}_db"
	echo -e "\033[1mБудет создана базы данных '${DB_NAME}':\033[0m";

	echo -e "\033[1mВВедите пароль для нового пользователя базы '${PROJECT}_user' :\033[0m";
	read -s DB_PASS
	# Создаем базу данных имя которой мы ввели
	echo -e "\033[1mТеперь будет необходимо ввести 2 раза пароль root MySQL, если пароля нет - просто нажмите Enter (2 раза)\033[0m";
	mysql -u root -p -e "CREATE DATABASE $DB_NAME"
	# Создаем нового пользователя (суперпользователя)
	mysql -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO ${PROJECT}_user@localhost IDENTIFIED by '$DB_PASS' WITH GRANT OPTION;"
	echo -e "\033[1mБаза данных $DB_NAME создана.\033[0m";
else
	echo -e "\033[1mБаза данных не была создана\033[0m";
fi

# создаем симлинк в домашней директории
ln -s $WWW/$DOMAIN/public $SYMLINK_FOLDER/$DOMAIN

touch $WWW/$DOMAIN/config.txt
echo -e "Name Project: $PROJECT\nURL: http://$DOMAIN\nDB_NAME:$DB_NAME\nDB_USER:${PROJECT}_user\nDB_PASS:$DB_PASS\nDirectory Project:$WWW/$DOMAIN/" >> $WWW/$DOMAIN/config.txt
echo ""
clear
echo "*************************************"
echo -e "\033[1mЛокальный сайт готов к работе.\033[0m"
echo -e "\033[1mФайл конфигурации находится в $WWW/$DOMAIN/config.txt\033[0m"
echo -e "\033[1mСоздан симлинк на проект в каталоге $SYMLINK_FOLDER\033[0m"
echo -e "\033[1mURL проекта: http://$DOMAIN\033[0m"
echo "*************************************"

# перезагрузка Apache
service apache2 restart