#!/bin/bash

clear

echo -e "\033[1mНачинаем большую чистку!\033[0m";
echo -e "\033[1m===================\033[0m";

echo -e "\033[1mКеш изображений:\033[0m";
rm -v -f ~/.cache/thumbnails/*/*.png ~/.thumbnails/*/*.png
rm -v -f ~/.cache/thumbnails/*/*/*.png ~/.thumbnails/*/*/*.png

echo -e "\033[1mКеш браузеров (chromium, mozilla), chrome не трогаем\033[0m";
#echo -e "\033[1mСоздание бекапов для отката:\033[0m";
#cp -r ~/.mozilla ~/.mozillabkp
#cp -r ~/.config/google-chrome ~/.config/google-chromebkp
#cp -r ~/.config/chromium ~/.config/chromiumbkp
#echo -e "\033[1mЧистка:\033[0m";
rm -r -v ~/.mozilla && rm -r -v ~/.cache/mozilla
rm -r -v ~/.config/chromium && rm -r -v ~/.cache/chromium


echo -e "\033[1mУдаление неиспользуемых пакетов:\033[0m";
sudo apt-get autoremove
