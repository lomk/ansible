#!/bin/bash

DATE=$(date +"%Y%m%d")
OLDDATE=$(date +"%Y%m%d" --date="5 days ago")

TMPDIR="/backup/tmp"
BKPDIR="/backup/"
ONKOPORTALSQL=$(printf "oncoportal.net.sql.%s.tar.gz" "$DATE")
OLD_ONKOPORTALSQL=$(printf "oncoportal.net.sql.%s.tar.gz" "$OLDDATE")
ONKOPORTALWEB=$(printf "oncoportal.net.web.%s.tar.gz" "$DATE")
OLD_ONKOPORTALWEB=$(printf "oncoportal.net.web.%s.tar.gz" "$OLDDATE")
CLINICSQL=$(printf "spizhenko.clinic.sql.%s.tar.gz" "$DATE")
OLD_CLINICSQL=$(printf "spizhenko.clinic.sql.%s.tar.gz" "$OLDDATE")
CLINICWEB=$(printf "spizhenko.clinic.web.%s.tar.gz" "$DATE")
OLD_CLINICWEB=$(printf "spizhenko.clinic.web.%s.tar.gz" "$OLDDATE")
ENCLINICWEB=$(printf "en.spizhenko.clinic.web.%s.tar.gz" "$DATE")
OLD_ENCLINICWEB=$(printf "en.spizhenko.clinic.web.%s.tar.gz" "$OLDDATE")
ENCLINICSQL=$(printf "en.spizhenko.clinic.sql.%s.tar.gz" "$DATE")
OLD_ENCLINICSQL=$(printf "en.spizhenko.clinic.sql.%s.tar.gz" "$OLDDATE")
BITRIX24SQL=$(printf "bitrix24.sql.%s.tar.gz" "$DATE")
OLD_BITRIX24SQL=$(printf "bitrix24.sql.%s.tar.gz" "$OLDDATE")
BITRIX24WEB=$(printf "bitrix24.web.%s.tar.gz" "$DATE")
OLD_BITRIX24WEB=$(printf "bitrix24.web.%s.tar.gz" "$OLDDATE")

#CHATID="113942689"
CHATID="-308014529"
KEY="681335735:AAG9ZqkfWCuUy-tr1F-dsg7WDd2e7IANkvQ"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"

notify() {
    if [ ! -z "$1" ]
        then
        logger -i  -p local0.notice $1
        curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$1" $URL
    fi
}

oncodb_bkp(){
ssh root@oncoportal  "mysqldump -u root -poncoportal2000 -B onko_portal xoro" > ${BKPDIR}oncoportal.net.sql
sleep 30
tar cz --remove-files -f ${BKPDIR}${ONKOPORTALSQL} ${BKPDIR}oncoportal.net.sql
sleep 30

if [ -f ${BKPDIR}${ONKOPORTALSQL} ]
then
    if [ -f ${BKPDIR}${OLD_ONKOPORTALSQL} ]
    then
	rm -f ${BKPDIR}${OLD_ONKOPORTALSQL}
    #notify "Succesfully created backup $ONCOPORTALSQL for oncoportal.net database"
    fi
else
    notify "ERROR: Backup for oncoportal.net  database on webserver failed"
fi


}


oncoweb_bkp(){
ssh root@oncoportal "tar czf - /var/www/oncoportal/" > ${BKPDIR}${ONKOPORTALWEB}
sleep 30

if [ -f ${BKPDIR}${ONKOPORTALWEB} ]
then
    if [ -f ${BKPDIR}${OLD_ONKOPORTALWEB} ]
    then
	rm -f ${BKPDIR}${OLD_ONKOPORTALWEB}
    fi
    #notify "Succesfully created backup $ONCOPORTALWEB for oncoportal.net web directories"
else
    notify "ERROR: Backup for oncoportal.net web directories failed"
fi
}

clinicdb_bkp(){
mysqldump -u cyberknife -ppass:N3s0Z6e7 cyberknife > ${BKPDIR}spizhenko.clinic.sql
sleep 30
tar cz --remove-files -f $BKPDIR$CLINICSQL ${BKPDIR}spizhenko.clinic.sql
sleep 30

if [ -f ${BKPDIR}${CLINICSQL} ]
then
    sleep 2
    if [ -f ${BKPDIR}${OLD_CLINICSQL} ]
    then
	rm -f ${BKPDIR}${OLD_CLINICSQL}
    fi
    #notify "Succesfully created backup $CLINICSQL for spizhenko.clinic database"
else
    notify "ERROR: Backup for spizhenko.clinic database failed"
fi
}


clinicweb_bkp(){
tar czf  ${BKPDIR}${CLINICWEB} /opt/clinic/spizhenko.clinic/ 
sleep 30

if [ -f ${BKPDIR}${CLINICWEB} ]
then
    sleep 2
    if [ -f ${BKPDIR}${OLD_CLINICWEB} ]
    then
	rm -f ${BKPDIR}${OLD_CLINICWEB}
    fi
    #notify "Succesfully created backup $CLINICWEB for spizhenko.clinic web directories"
else
    notify "ERROR: Backup for spizhenko.clinic web directories failed"
fi
}



enclinicdb_bkp(){
mysqldump -u en_spizhenko -pW9g4D8p0 en_spizhenko > ${BKPDIR}en.spizhenko.clinic.sql
sleep 30
tar cz --remove-files -f $BKPDIR$ENCLINICSQL ${BKPDIR}en.spizhenko.clinic.sql
sleep 30

if [ -f ${BKPDIR}${ENCLINICSQL} ]
then
    sleep 2
    if [ -f ${BKPDIR}${OLD_ENCLINICSQL} ]
    then
	rm -f ${BKPDIR}${OLD_ENCLINICSQL}
    fi
    #notify "Succesfully created backup $CLINICSQL for spizhenko.clinic database"
else
    notify "ERROR: Backup for en.spizhenko.clinic database failed"
fi
}

enclinicweb_bkp(){
tar czf  ${BKPDIR}/${ENCLINICWEB} /opt/clinic/en.spizhenko.clinic/ 
sleep 30

if [ -f "${BKPDIR}/${ENCLINICWEB}" ]
then
    sleep 2
    if [ -f "${BKPDIR}/${OLD_ENCLINICWEB}" ]
    then
        rm -f ${BKPDIR}/${OLD_ENCLINICWEB}
    fi
    #notify "Succesfully created backup $CLINICWEB for spizhenko.clinic web directories"
else
    notify "ERROR: Backup for en.spizhenko.clinic web directories failed"
fi
}

bitrix24db_bkp(){
mysqldump -u root -poVKBzVF2bQtrGxXngGKoNLNe bitrix24 > ${BKPDIR}bitrix24.sql
sleep 30
tar cz --remove-files -f ${BKPDIR}${BITRIX24SQL} ${BKPDIR}bitrix24.sql
sleep 30

if [ -f ${BKPDIR}${BITRIX24SQL} ]
then
    sleep 2
    if [ -f ${BKPDIR}${OLD_BITRIX24SQL} ]
    then
	rm -f ${BKPDIR}${OLD_BITRIX24SQL}
    fi
    #notify "Succesfully created backup $CLINICSQL for spizhenko.clinic database"
else
    notify "ERROR: Backup for bitrix24 database failed"
fi
}

bitrix24web_bkp(){
tar czvf  ${BKPDIR}${BITRIX24WEB} /opt/bitrix24/ --exclude "/opt/bitrix24/upload/uf" --exclude "/opt/bitrix24/bitrix/backup"
sleep 30

if [ -f "${BKPDIR}${BITRIX24WEB}" ]
then
    sleep 2
    if [ -f "${BKPDIR}${OLD_BITRIX24WEB}" ]
    then
        rm -f ${BKPDIR}/${OLD_BITRIX24WEB}
    fi
    #notify "Succesfully created backup $CLINICWEB for spizhenko.clinic web directories"
else
    notify "ERROR: Backup for bitrix24 web directories failed"
fi
}

oncodb_bkp
oncoweb_bkp
clinicdb_bkp
clinicweb_bkp
enclinicdb_bkp
enclinicweb_bkp
bitrix24db_bkp
bitrix24web_bkp

