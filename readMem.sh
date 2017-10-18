#!/bin/bash
readRam()
{
printf "\t\tArbeitsspeicher: `getconf PAGESIZE`"
}

readMain()
{
meminfo=`cat /proc/meminfo`
set $meminfo
mainKb=$2
mainMb=$(($mainKb/1024))
printf "\t\tHauptspeicher: $mainMb MB"
}

main()
{
printf "\n"
printf "\n\t*****************************************************************\n"
printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "User: $USER" "Rechner: `hostname`" "*"
printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Arbeitsspeicher auslesen" "--> 1" "*"
printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Hauptspeicher auslesen" "--> 2" "*"
printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Beenden" "--> q" "*"
printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
printf "\t*****************************************************************\n"
printf "\tIhre Wahl:"
read wahl
case $wahl in
		#Arbeitsspeicher auslesen
	1)	readRam
		main;;

		#Hauptspeicher auslesen
	2)	readMain
		main;;

		#Skript beenden
	q)	clear
		exit;;
		
		#Ungueltige Eingabe
	*) 	printf "Bitte waehlen Sie eine gueltige Menuefunktion aus.\n"
esac
}
main
