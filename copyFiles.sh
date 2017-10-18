#!/bin/bash
#Skript: Kopiert alle Dateien im uebergebenen Ordner

#Funktion zum Kopieren des Dateien
copy()
{	
	COUNTER=0
	for FILE in $(ls $ORDNER)
		#Kontrolle ob die letzten drei Zeichen des Dateinames bak sind einfuegen.
		do 	cp ${ORDNER}$FILE ${ORDNER}${FILE}.bak
			COUNTER=$(($COUNTER+1))					
	done
	return $COUNTER
}

#Menuefuehrung und Aufruf

#Ueberpruefen ob ein Argument uebergeben wurde
if [ "$#" = 0 ]
	then 	echo "Sie muessen einen Ordner uebergeben!"
		exit 1
fi
ORDNER=$1

#Ausgabe des uebergebenen Arguments
echo -e "Der zu kopierende Ordner ist: $1"

#Abfrage ob dieser Ordner wirklich kopiert werden soll
echo -e "\n Moechten Sie diesen Ordner kopieren? y/n \c"
read bestaetigung
ENDLSCHL=1
while test $ENDLSCHL=1
do
	if [ "$bestaetigung" = "n" ]
		then 	exit 2
	elif [ "$bestaetigung" = "y" ]
		then 	copy 
			echo -e "Es wurden $? Kopiervorgaenge ausgefuehrt."
			break
	else echo -e "\n Dies war keine gueltige Eingabe!"
	fi
done

#Loeschen der Funktion und Ende des Shells
unset copy
exit 0
