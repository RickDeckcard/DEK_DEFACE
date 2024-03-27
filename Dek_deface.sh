#!/bin/bash

# Script creado por Deckcard23

# Definir colores
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
BYellow='\033[1;33m'      # Yellow Bold
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
NC='\033[0m' # No Color

# Funciones
BANNER(){
clear
echo
echo -e "${BYellow} _____   _______      _    _____   _______________      _______________"
echo "(____ \ (_______) |  / )  (____ \ (_______|_______)\   / _____|_______)"
echo " _   \ \ _____  | | / /    _   \ \ _____   _____ /  \ | /      _____   "
echo "| |   | |  ___) | |< <    | |   | |  ___) |  ___) /\ \| |     |  ___)  "
echo "| |__/ /| |_____| | \ \   | |__/ /| |_____| |  | |__| | \_____| |_____ "
echo "|_____/ |_______)_|  \_)  |_____/ |_______)_|  |______|\______)_______)"
}

DELETE(){
if [ -e web1.log ]
then
	rm web1.log
	echo "Limpiando web1.log..."
fi
if [ -e web2.log ]
then
	rm web2.log
	echo "Limpiando web2.log..."
fi
if [ -e web3.log ]
then
	rm web3.log
	echo "Limpiando web3.log..."
fi
}

MENU(){
echo
echo -e "${Yellow}Datos del ultimo fallo en la web."
cat date_cron.log | tail -n 2
echo
echo -e "${White}MENU"
echo -e "${Red}----"
echo
echo -e "${Blue}1. Obtener hash de pagina."
echo -e "2. Poner en marcha DEK_DEFACE."
echo -e "0. Terminar."
}


# Main Code
salir=1
until [ $salir -eq 0 ]
do
BANNER
MENU
read opcion
case $opcion in

	1)
		conta=1
		until [ $conta -eq 0 ]
		do
		echo -n -e "${White}Elige 1 para introducir url o 0 para salir: "
		read opcion
		case $opcion in
			1)
			echo -e "${Purple}Deckcard23 Check urls to daface urls.txt file..."
			echo -n -e "${White}Introduce la url para obtener hash (ejemplo: https://google.com): "
			read url_name
			echo -n "Elige el numero de lineas a leer:"
			read head_line
			curl -s -X GET $url_name | html2text | head -n $head_line > web1.log
			md5_file=$(cat web1.log | md5sum | cut -f1 -d " ")
			echo -e "${Yellow}El hash es: $md5_file"
			;;
			0)
			echo -e "${Red}Saliendo del check de md5 en urls."
			conta=0
			;;
			*)
			echo -e "${Red}Elige opcion 1 o 0, por favor"
			;;
		esac
		done
		;;
	2)
		contador=1
		echo -n -e "${White}Elige el tiempo de escaneo de las urls, en segundos: "
		read segun
		until [ $contador -eq 0 ]
		do
		echo -e "${Yellow}Deckcard23 Defacement protection up...."
			sleep $segun

			while read line
			do
				DELETE
				url_name=$(echo "$line" | cut -f1-2 -d ":")
				echo -e "${Yellow}Creando fichero: web1.log"
				echo -e "${Green}Analizando: $url_name"
				head_line=$(echo "$line" | cut -f3 -d ":")
				curl -s -X GET $url_name | html2text | head -n $head_line > web1.log
				echo -e "${White}Comprobando integridad de $url_name"
				md5_file=$(cat web1.log | md5sum | cut -f1 -d " ")
				md5_url=$(echo "$line" | cut -f4 -d ":")
				echo "MD5 file $md5_file"
				echo "MD5 url $md5_url"

				if [ "$md5_file" == "$md5_url" ]
					then
						echo -e "${Yellow}Status correcto."
						echo -n -e "${Cyan}Correcto $url_name: "

					else
						echo -e "${Red}Deface in $url_name detected."
				if [ -e defacement.log ]
					then
						rm defacement.log
				fi
				echo
				echo -e "${White}------DEFACEMENT IN WEBSITE------"
				echo -e "${Yellow}       -----warning-----"
				echo -e "${Red}URL con dafecement: $url_name" >> date_cron.log
				echo -n "Defacement or Problem: " >> date_cron.log
				date >> date_cron.log
				fi

			done < urls.txt
		done
		
				;;
	0)	
		echo
		echo -e "${Cyan}Gracias por usar DEK_DEFACE."
		echo -e "${White}No olvide seguirme en mis redes sociales y suscribirse al canal de YouTube."
		echo -e "${Yellow}YouTube: @rickdeckard4788"
		echo "X: @rickdeckard23"
		echo "web: deckcard23.com"
		echo "email: info@deckcard23.com"
		salir=0
		exit
		;;
	*)
		echo -e "${Red}Debe elegir 1,2 o 0."
		;;
esac
done



