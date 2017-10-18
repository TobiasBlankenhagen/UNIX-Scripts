#!/bin/bash
printf "\n"
case $# in
	0)	while test 1=1
		do
			printf "Bitte uebergeben Sie das Skript wo das Menue eingefuegt werden soll: "
			read menueSkript
			if test -n $menueSkript 
				then break
			fi
		done
		while test true
		do
			printf "Bitte uebergeben Sie die Anzahl der Optionen im Menue: "
			read lineCount
			if test -n $lineCount 
				then break
			fi
		done;;
	1)	isLine=`echo $1|egrep -s [0-9]\{1,\}`
		if test "$isLine" != ""
			then	lineCount=$1
				while test true
				do
					printf "Bitte uebergeben Sie das Skript wo das Menue eingefuegt werden soll: "
					read menueSkript
					if test -n $menueSkript 
						then break
					fi
				done
		elif test $1 == `echo $1|egrep [*.sh]`
			printf "1: $1\n"			
			then menueSkript=$1
				while test true
				do
					printf "Bitte uebergeben Sie die Anzahl der Optionen im Menue: "
					read lineCount
					if test -n $lineCount
						then break
					fi			
				done
		else 	printf "Aufruf fehlgeschlagen!\n"
			exit
		fi;;
	2)	isLine=`echo $1|egrep -s [0-9]\{1,\}`
		isSkript=`echo $2|egrep [*.sh]`
		#$1 ist zeilenanzahl, $2 ist Skript
		if test "$isLine" != "" -a "$2" == "$isSkript"
			then 	lineCount=$1
				menueSkript=$2		
		else	isLine=`echo $2|egrep -s [0-9]\{1,\}`
			isSkript=`echo $1|egrep [*.sh]`
			#$1 ist Skript , $2 ist Zeilenanzahl
			if test "$1" == "$isSkript" -a "$isLine" != ""
				then 	menueSkript=$1
					lineCount=$2
			else 	printf "Aufruf fehlgeschlagen!\n"
				#printf "1: $1, 2: $2 \n"
				#printf "isLine $isLine \n"
				#printf "menueSkript: $menueSkript, lineCount: $lineCount \n"
				exit
			fi		
		fi;;
	*)	printf "Sie haben zu viele Argumente uebergeben." 
		exit
esac
while test true
do
	#Pruefen ob die Datei existiert, ansonsten erstellen
	if test -f $workFile
		then	printf "Wollen Sie in das Skript $menueSkript schreiben? y/n: "
			read eingabe
			if test -n $eingabe
				then break
			fi
	else
		touch $workFile
	fi
done
if test "$eingabe" = "y"
then
ed -s $menueSkript <<EOF
a
while test "$wahl" != "q" -a "$wahl" != "Q"
do
printf "\n"
printf "\n\t*****************************************************************\n"
printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "User: \$USER" "Rechner: \`hostname\`" "*"
.
w
q
EOF
returnCount=$?
counter=1
while test $counter -le $lineCount
do
ed -s $menueSkript <<EOF
a
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Menuepunkt $counter" "--> $counter" "*"
.
w
q
EOF
returnCount=$(($returnCount+$?))
counter=$(($counter+1))
done
ed -s $menueSkript <<EOF
a
	printf "\t%-1c\t%-34s%-15s\t%1s\n" "*" "Beenden" "--> q" "*"
	printf "\t%-1c\t%-52s\t%1s\n" "*" " " "*"
	printf "\t*****************************************************************\n"
	printf "\tIhre Wahl:"
	read wahl
	case \$wahl in
.
w
q
EOF
counter=1
while test $counter -le $lineCount
do
ed -s $menueSkript <<EOF
a
		$counter)	if test -z \$workFile 
						then	printf "Bitte legen Sie zuerst die Datei fest die bearbeitet werden soll."
							main
						else	...
					fi;;
.
w
q
EOF
counter=$(($counter+1))
done
ed -s $menueSkript <<EOF
a

			#Skript beenden
		q)	printf "Programm beenden... \n";;
		
			#Ungueltige Eingabe
		*) 	printf "Bitte waehlen Sie eine gueltige Menuefunktion aus.\n"
	esac
done
.
w
q
EOF
returnCount=$(($returnCount+$?))
else exit
fi
worstCase=$(($lineCount*2+2))
if test $returnCount == 0 
	then printf "Menue erfolgreich erzeugt.\n"
elif test $returnCount -le $worstCase 
	then printf "Menue konnte nicht vollstaendig erzeugt werden.\n"
elif test $returnCount -gt $worstCase 
	then printf "Menue konnte nicht erzeugt werden.\n"
fi
