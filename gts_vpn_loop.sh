#/bin/bash
while :
	do
		if [ ! -d /sys/class/net/ppp0 ]; then
			echo "$(date) activating geant vpn"
			pon geant
		#else
			#echo "geant vpn is already active"
		fi
		sleep 5
	done
