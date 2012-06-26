#! /bin/env bash
if [ -e ".tnrs_handler.pid" ]; then
		OPID=$(cat .tnrs_handler.pid)
		
		if ps aux | sed -r 's/\s+/\t/g' |cut -f 2 | grep ${OPID} 1> /dev/null; then
			kill ${OPID}
			echo "TNRastic successfully stopped."
			exit 0
		fi
fi
echo "TNRastic is not currently running"