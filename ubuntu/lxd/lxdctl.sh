#!/bin/bash

conf="/etc/default/lxd_dnsmasq.conf"
LXD_ADMIN="lxdadm"

usage () {
  echo "Usage:"
  echo "  ./lxdctl.sh create <container name> <container ip> <image name>"
  echo "  ./lxdctl.sh remove <container name>"
  echo "  ./lxdctl.sh <lxc command and parameters>"
  echo "  ./lxdctl.sh help"
  exit 1
}

func1 ()
{
  sh -c "echo '$2 $1' >> /etc/hosts"
  sh -c "echo 'dhcp-host=$1,$2' >> $conf" && echo $2 $1 && service lxd-bridge stop && service lxd-bridge start 
  su -c "lxc launch $3 $1" ${LXD_ADMIN}

  wait

  su -c "lxc restart $1" ${LXD_ADMIN} 
  wait
  if [[ $3 == tiqc-ubuntu* ]];  
  then  
    sleep 20
    su -c "lxc exec $1 -- userdel ubuntu" ${LXD_ADMIN}
    su -c "lxc exec $1 -- sed -i 's/localhost/locahost $1/g' /etc/hosts" ${LXD_ADMIN}
  fi
  echo done

}

func2 ()
{
  if [ $# -ne 3 ]; then
    echo "Input error. Please check you input."
    usage
  fi
  if grep -q -w $1 $conf
  then
    str0=$(printf "There is already an entry for $1 in the lxd_dnsmasq.conf file.\nMake sure that no existing container is using that name (lxc list) before proceeding.\nChoose y to overwrite the existing entry for $2 and continue.\nChoose n to end this script") echo "$str0"
    read
    if [[ $REPLY == [Nn] ]]
    then
      exit 0
    elif [[ $REPLY == [Yy] ]]
    then
      if grep -q -w $2 $conf
      then
        str1=$(printf "The ip address $2 is already in the lxd_dnsmasq.conf file.\nMake sure that no existing container is using that address (lxc list) before proceeding.\nChoose y to overwrite the existing entry for $2 and continue.\nChoose n to end this script") echo "$str1"
        read
        if [[ $REPLY == [Nn] ]]
        then
          exit 0
        elif [[ $REPLY == [Yy] ]]
        then
          sed -i "/$2/d" $conf
          sed -i "/$1/d" $conf
          sed -i "/$2/d" /etc/hosts
          func1 $1 $2 $3
        fi
      else
        sed -i "/$1/d" $conf
        sed -i "/$2/d" /etc/hosts
        func1 $1 $2 $3
      fi
    else
      func1 $1 $2 $3
    fi

  elif grep -q -w $2 $conf
  then
    str1=$(printf "The ip address $2 is already in the lxd_dnsmasq.conf file.\nMake sure that no existing container is using that address (lxc list) before proceeding.\nChoose y to overwrite the existing entry for $2 and continue.\nChoose n to end this script") echo "$str1"
    read
    if [[ $REPLY == [Nn] ]]
    then
      exit 0
    elif [[ $REPLY == [Yy] ]]
    then
      sed -i "/$2/d" $conf
      sed -i "/$2/d" /etc/hosts
      func1 $1 $2 $3
    fi
  else
    func1 $1 $2 $3
  fi
}

case "$1" in
  (create)
    func2 $2 $3 $4
    ;;

  (remove)
    su -c "lxc stop $2" ${LXD_ADMIN}
    wait
    su -c "lxc delete $2" ${LXD_ADMIN}
    sed -i "/$2/d" $conf
    sed -i "/$2/d" /etc/hosts
    ;;

  (help)
    usage
    ;;

  (*)
    su -c "lxc $*" ${LXD_ADMIN}
    ;;
esac
exit 0
