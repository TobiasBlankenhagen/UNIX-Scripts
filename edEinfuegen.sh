#!/bin/bash

einfuegenVor()
{
(
zeilennummer=`grep -n "$suchText" $workFile| awk -F: '{printf $1}'`
ed -s $workFile <<EOF
${zeilennummer}
-1a
${einzufuegenderText}
.
w
q
EOF
kontrolle
)
}

einfuegenNach()
{
zeilennummer=`grep -n "$suchText" $workFile | awk -F: '{printf $1}'`
printf "Zeilennummer: $zeilennummer"
ed -s $workFile <<EOF
${zeilennummer}
+1a
${einzufuegenderText}
.
w
q
EOF
kontrolle
}

einfuegenAn()
{
einfuegenZeile=$(($einfuegenZeile-1))
ed -s $workFile <<EOF
${einfuegenZeile}
a
${einzufuegenderText}
.
w
q
EOF
kontrolle	
}

zeitstempelEinfuegen()
{
einfuegenZeile=$(($einfuegenZeile-1))
zeitstempel="`date +%d/%m/%y` von:$USER"
ed -s $workFile  <<EOF
${einfuegenZeile}
a
${zeitstempel}
.
w
q
EOF
kontrolle
}

kontrolle()
{
if test $? == 0
	then printf "Text erfolgreich eingefuegt."
else printf "Text konnte nicht erfolgreich eingefuegt werden."
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
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Einfuegen vor..." "--> 1" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Einfuegen nach..." "--> 2" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Einfuegen an..." "--> 3" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Zeitstempel Einfuegen" "--> 4" "*"
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Beenden" "--> q" "*"
	printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
	printf "\t*****************************************************************\n"
	printf "\tIhre Wahl:"
	read eingabe
	case $eingabe in
			#Vor Suchstring einfuegen	
		1)	if test -z $workFile 
					then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
						main
					printf "Zu suchendes Wort: "
						read suchText
						printf "einzufuegender Text: "
						read einzufuegenderText
						einfuegenVor
				fi;;
			
			#Nach Suchstring einfuegen
		2)	if test -z $workFile 
				then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
					main
				else	printf "Zu suchendes Wort: "
					read suchText
					printf "einzufuegender Text: "
					read einzufuegenderText
					einfuegenNach
			fi;;

			#An Zeile einfuegen
		3)	if test -z $workFile 
					then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
						main
					else	printf "Zeile: (Bsp: 1): "
						read einfuegenZeile
						printf "Einzufuegender Text: "
						read einzufuegenderText
						einfuegenAn
			fi;;

			#Zeitstempel einfuegen
		4)	if test -z $workFile 
					then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
						main
					else	printf "Zeile: (Bsp: 1): "
						read einfuegenZeile
						zeitstempelEinfuegen
				fi;;
		q)	clear
			exit;;
		*) 	printf "Bitte waehlen Sie eine gueltige Menuefunktion aus.\n"
	esac
main
}
dateiKontrolle $1
main
