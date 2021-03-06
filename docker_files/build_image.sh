#!/bin/bash
function install_weblogic {
  apt-get install -y unzip

  cd /weblogic/
  #echo "Downloading weblogic..."
  #wget --progress=bar:force --no-check-certificate "https://www.dropbox.com/s/3h3h839qbk0hjss/w1213d_3.zip" -O wls1213_dev_update3.zip
  echo "Unpacking weblogic..."
  unzip wls1213_dev_update3.zip
  rm -f wls1213_dev_update3.zip
  cd wls12130
  echo "Configuring weblogic..."
  ./configure.sh -silent

  mv -f /weblogic/configure.sh /weblogic/wls12130/configure.sh
  mv -f /weblogic/wlst.sh /weblogic/wls12130/oracle_common/common/bin/wlst.sh
  chmod 755 /weblogic/wls12130/oracle_common/common/bin/wlst.sh

}
install_weblogic
