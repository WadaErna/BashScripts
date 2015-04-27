#!/bin/bash

#: Title	:: adBlock.sh
#: Date		:: 17/03/15
#: Description	:: Blocking adversiting via host file
#: Version	:: 0.1
#: Autor	:: Wada Erna

startTime=$(date +%s)
adHosts="/etc/hosts"
adHstBK="/etc/hosts.bk"
tmpTrash="/tmp/trash"
tmpLineOut="/tmp/lineout"

declare -a myUrls=( 
    http://winhelp2002.mvps.org/hosts.txt 
    http://www.malwaredomainlist.com/hostslist/hosts.txt )
declare -a tmpFiles=()

fncDownload() {
    printf ":: Start DB update \n"
    for((i=0; i<=$((${#myUrls[@]}-1));i++)); do
	rute="/tmp/FO$i.txt"
	curl -o $rute -O ${myUrls[$i]} &> /dev/null
	tmpFiles+=("$rute")
    done
    printf ":: Download all DB\n"
}

fncHostBackup() {
    if [[ -f /etc/hosts.bk ]]; then
	printf "!! There is a copy of hosts, skiping a backup\n"
    else
	printf ":: Making a copy of hosts\n"
	sudo bash -c "cp $adHosts $adHstBK"
    fi
}

fncClean(){
    for((i=0; i<=$((${#tmpFiles[@]}-1));i++)); do
	egrep -v "localhost" ${tmpFiles[$i]} > $tmpLineOut
	cat $tmpLineOut | col -b >> $tmpTrash
    done
    printf ":: Cleaned all files\n"
}

fncReplaceHost(){
    sudo bash -c "cat $adHstBK $tmpTrash > $adHosts"
    printf ":: Replace host complete\n"
}

fncDelete(){
    sudo bash -c "rm $tmpTrash $tmpLineOut"
    for((i=0; i<=$((${#tmpFiles[@]}-1));i++)); do
	sudo bash -c "rm ${tmpFiles[$i]}"
    done
    unset myUrls
    unset tmpFiles
    printf ":: Unset and delete all files\n"
}

fncMain(){
    fncDownload 
    fncHostBackup
    fncClean
    fncReplaceHost
    fncDelete
}

fncMain

endTime=$(date +%s)
printf "Runing Time: %d\n" $(($endTime-$startTime))
