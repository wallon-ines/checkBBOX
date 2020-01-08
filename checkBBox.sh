#! /bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing,
#   software distributed under the License is distributed on an
#   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#   KIND, either express or implied.  See the License for the
#   specific language governing permissions and limitations
#   under the License.

# Script de monitoring et de reboot de bbox

. ./config

BBOX_URL="mabbox.bytel.fr"
HOST_TO_PING=${HOST_TO_PING:-www.google.fr}

reboot_bbox(){
	# Authentification
	COOKIE="/tmp/cookie-bbox"
	if [ -e ${COOKIE} ]; then
		echo "Suppression du cookie précédant"
		rm ${COOKIE}
	fi
  curl -d "password=${PASSWORD}" -c ${COOKIE}  https://${BBOX_URL}/api/v1/login

	# Récupération du jeton
	echo "Récupération du jeton"
  TOKEN=`curl -s --cookie ${COOKIE} https://${BBOX_URL}/api/v1/device/token | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[0]["device"]["token"]'`

	# Reboot
	echo "Reboot de la box"
  curl -d "" --cookie ${COOKIE} https://mabbox.bytel.fr/api/v1/device/reboot?btoken=${TOKEN}
	if [ $? = 0 ];
  then
		echo "Redémarrage en cours..."
		# Pause de 2mn pour permettre le redémarrage complet et l'envois du mail
		sleep 120
    ping -c1 $HOST_TO_PING -W1 2>&1 > /dev/null
    if [ $? = 0 ] ; then
      echo "[Bbox] Reboot OK at $(date '+%d/%m/%Y %H:%M')" | mail -s "[Bbox] reboot" ${MAIL}
    fi
  else
		echo "Échec du redémarrage"
	fi

	rm ${COOKIE}

}


check_connection(){
	ping -c1 $HOST_TO_PING -W1 2>&1 > /dev/null
	if [ $? != 0 ] ; then
		echo "Impossible de joindre $HOST_TO_PING "
		reboot_bbox
	fi
}

check_connection

