#!/bin/bash

woertLoeschen()
{
ed -s $workFile <<EOF
1,$ s/${loeschText}//g
w
q
EOF
kontrolle
}

zeilenLoeschen()
{
(
IFS='-'
set $loeschText
loeschAnfang=$1
loeschEnde=$2
if test  -z $loeschEnde
	then loeschEnde=$loeschAnfang
fi
ed -s $workFile <<EOF
${loeschAnfang},${loeschEnde} d
.
w
q
EOF
)
kontrolle
}

zeichenLoeschen()
{
array=`echo $loeschWort | awk '{split($0, array, ""); print array[1], array[2], array[3], array[4], array[5], array[6], array[7]}'`
for c in $array
do
if test $c != $loeschText
	then newWord=$newWord$c
fi
done
printf $newWord
ed -s $workFile <<EOF
1,$ s/${loeschWort}/${newWord}/g
.
w
q
EOF
kontrolle
}

kontrolle()
{
if test $? == 0
	then printf "Text erfolgreich geloescht."
else printf "Text konnte nicht erfolgreich geloescht werden."
fi
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
	printf "\n\t*****************************************************************\n"
	printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Bearbeitungsdatei:" "$workFile" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Datei festlegen" "--> 1" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Woert loeschen" "--> 2" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Zeilen loeschen" "--> 3" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Zeichen loeschen" "--> 4" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Beenden" "--> q" "*"
	printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
	printf "\t*****************************************************************\n"
	printf "\tIhre Wahl:"
	read eingabe
		case $eingabe in
				#Datei festlegen
			1)	printf "Zu bearbeitende Datei: "
				read workFile
				main;;
				#Woert loeschen
			2)	if test -z $workFile 
					then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
						main
					else	printf "Zu loeschendes Wort: "
						read loeschText
						woertLoeschen
				fi;;

				#Zeilen loeschen
			3)	if test -z $workFile 
					then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
						main
					else 	printf "Zu loeschende Zeilen (Bsp: 1 oder 1-2): "
						read loeschText
						zeilenLoeschen
				fi;;

				#Zeichen loeschen
			4)	if test -z $workFile 
					then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
						main
					else 	printf "Zu bearbeitendes Wort: "
						read loeschWort
						printf "Zu loeschendes Zeichen (Bsp: a): "
						read loeschText						
						zeichenLoeschen
				fi;;
				
				#Zurueck ins Menue
			q)	clear
				exit;;
			*) 	printf "Bitte machen waehlen Sie eine gueltige Menuefunktion aus.\n"
		esac
main
}
dateiKontrolle $1
main
