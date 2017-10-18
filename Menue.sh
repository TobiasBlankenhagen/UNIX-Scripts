#!/bin/bash

ersetzen()
{
ed -s $workFile <<EOF
1,$ s/${ersetzText}/${einsetzText}/g
w
q

EOF
if test $? == 0
	then printf "Text erfolgreich ersetzt."
else printf "Text konnte nicht erfolgreich ersetzt werden."
fi
}

anhaengen()
{
ed -s $workFile <<EOF
a
${anhaengText}
.
w
q
EOF
if test $? == 0
	then printf "Text erfolgreich angehaengt."
else printf "Text konnte nicht erfolgreich angehaengt werden."
fi
}

suchen()
{
(
IFS=$'\n'
suchergebniss=`grep -n "$suchText" $workFile`
if test -n $suchergebniss
	then	printf "Es wurde kein Vorkommen gefunden!"
else
	set $suchergebniss 
	for zeile in $suchergebniss
		do printf "$zeile \n"
	done
fi
)
}

kopieren()
{
(
IFS='-'
set $kopieText
kopieZeile=$(($kopieZeile-1))
kopieAnfang=$1
kopieEnde=$2
if test -z kopieende
	then kopieEnde=$kopieAnfang
fi
ed -s $workFile <<EOF
${kopieAnfang},${kopieEnde}t${kopieZeile}
.
w
q
EOF
)
}

dateiSplitten()
{
(
printf "Soll von unten gesplittet werden ? (y/n)"
read wahl
if test "$wahl" == "y"
	then 	IFS=':'
		letzteZeile=`tail -n 1 $workFile`
		letzteZeile=`grep -n "$letzteZeile" $workFile`
		set $letzteZeile
		letzteZeile=$1
		splitt=$(($letzteZeile-$splitZeile))	
		tail -n $splitt $workFile >> $splitFile
	elif test "$wahl" == "n"
		then 	head -n $splitZeile $workFile >> $splitFile 
	else printf "!!!FALSCHE EINGABE!!!"
fi
)
}

dateiKontrolle()
{
if test -z $workFile 
	then	if test $# -gt 0
			then workFile=$1
		fi
fi
}

main()
{
	printf "\n"
	printf "\n\t*****************************************************************\n"
	printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
	printf "\t%-1c\t%-52s\t%1s\n" "*" "Welche Funktion wollen Sie nutzen?" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Bearbeitungsdatei:" "$workFile" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Datei festlegen" "--> 1" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Ersetzen" "--> 2" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Loeschen" "--> 3" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Anhaengen" "--> 4" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Einfuegen" "--> 5" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Kopieren" "--> 6" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Suchen" "--> 7" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Datei splitten" "--> 8" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Speicher auslesen" "--> 9" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Beenden" "--> q" "*"
	printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
	printf "\t*****************************************************************\n"
	printf "\tIhre Wahl:"
	read eingabe
	case $eingabe in
			#Datei Festlegen
		1)	printf "Zu bearbeitende Datei: "
			read workFile
			main;;
			
			#Text ersetzen
		2)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			printf "Zu ersetzender Text: "
			read ersetzText
			printf "Einzusetzender Text: "
			read einsetzText
			ersetzen;;

			#Text loeschen
		3)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi			
			./edLoeschen.sh $workFile;;

			#Text Anhaengen
		4) 	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			printf "Anzuhaengender Text: "
			read anhaengText
			anhaengen;;
			
			#Text einfuegen
		5)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			./edEinfuegen.sh $workFile;;

			#Text Kopieren
		6)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			printf "Zu kopierender Zeile (Bsp: 1 oder 1-2): "
			read kopieText
			printf "In welche Zeile soll kopiert werden: "
			read kopieZeile
			kopieren;;
			
			#Suchen
		7)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			printf "Zu Suchender Text: "
			read suchText
			suchen;;
			
			#Datei splitten	
		8)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			printf "Ab welcher Zeile soll gesplittet werden: "
			read splitZeile
			printf "In welche soll Datei verschoben werden: "
			read splitFile
			dateiSplitten;;
			
			#Speicher auslesen
		9)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
			fi
			./readMem.sh;;
			
	
			#Skript beenden
		q)	clear
			exit;;
			#Ungueltige Eingabe
		*) 	printf "Bitte waehlen Sie eine gueltige Menuefunktion aus.\n"
		esac
main
}
dateiKontrolle $1
main
