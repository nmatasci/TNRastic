#! /bin/env bash
while getopts "f" opt; do
                        OPID=$(ps aux | grep "perl tnrs_handler.pl" | grep  -v grep|sed -r 's/\s+/\t/g' |cut -f 2)
			for CPID in ${OPID} ; do
				OK=$(kill ${CPID})
				echo "${CPID} $OK"
				if [ -z "$OK" ]; then
					echo "You are not allowed to stop TNRastic."
					exit 1
				fi
                        done
                        echo "TNRastic successfully stopped."
                        exit
done
if [ -e ".tnrs_handler.pid" ]; then
		OPID=$(cat .tnrs_handler.pid)
		
		if ps aux | sed -r 's/\s+/\t/g' |cut -f 2 | grep ${OPID} 1> /dev/null; then
			OK=$(kill ${OPID})
			if [ -z "$OK" ]; then
			echo "TNRastic successfully stopped."
			exit 
			fi
		fi
fi
echo "TNRastic is not currently running"
