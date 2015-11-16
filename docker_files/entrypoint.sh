#!/bin/bash

if [ "$(ls -A $MW_HOME)" ]; then
     echo "No action $MW_HOME is not Empty"
     
else
    echo "Take action $MW_HOME is not Empty"
    /weblogic/build_image.sh
fi

set -e

if [ "$#" -gt 0 ]; then
	$@
	exit $?
fi

if [ -z "$DOMAIN_DIR" ]; then
	DOMAIN_DIR=/weblogic/domains
	echo "DOMAIN_DIR environment variable not set. Using default: $DOMAIN_DIR"
	export DOMAIN_DIR
fi

if [ -z "$DOMAIN_NAME" ]; then
	DOMAIN_NAME=mydomain
	echo "DOMAIN_NAME environment variable not set. Using default: $DOMAIN_NAME"
	export DOMAIN_NAME
fi

$MW_HOME/wlserver/server/bin/setWLSEnv.sh

if [ "$(ls -A $DOMAIN_DIR/$DOMAIN_NAME)" ] ; then
  echo "Domain $DOMAIN_DIR/$DOMAIN_NAME already exists. Using it."		
else
  echo "Creating domain..."

	if [ -z "$SERVER_START_MODE" ]; then
		SERVER_START_MODE="dev"
		echo "SERVER_START_MODE environment variable not set. Using default: $SERVER_START_MODE"
		export SERVER_START_MODE
	fi

	if [ -z "$WEBLOGIC_PASSWD" ]; then
		WEBLOGIC_PASSWD="weblogic123"
		echo "WEBLOGIC_PASSWD environment variable not set. Using default: $WEBLOGIC_PASSWD"
		export WEBLOGIC_PASSWD
	fi

  mkdir -p $DOMAIN_DIR/$DOMAIN_NAME
	set +e

        if [ ! -f "$MW_HOME/exported_domain.jar" ] ; then
		$MW_HOME/wlserver/common/bin/wlst.sh /weblogic/myDomain.py
	else
		$MW_HOME/oracle_common/common/bin/unpack.sh -template=$MW_HOME/exported_domain.jar -domain=$DOMAIN_DIR/$DOMAIN_NAME	
        fi
  
	if [ $? -ne 0 ]; then
		echo "Failed to create domain $DOMAIN_DIR/$DOMAIN_NAME."
		rm -rf $DOMAIN_DIR/$DOMAIN_NAME
		sleep infinity
		exit 1
	fi
	set -e
fi

unset WEBLOGIC_PASSWD

${DOMAIN_DIR}/${DOMAIN_NAME}/bin/setStartupEnv.sh
${DOMAIN_DIR}/${DOMAIN_NAME}/startWebLogic.sh || sleep infinity
