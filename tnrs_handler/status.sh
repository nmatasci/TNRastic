#! /bin/env bash
if [ -e ".tnrs_handler.pid" ]; then
		OPID=$(cat .tnrs_handler.pid)
		if ps aux | sed -r 's/\s+/\t/g' |cut -f 2 | grep ${OPID} 1> /dev/null; then
			echo "TNRastic is running (PID: ${OPID})."
			exit 0
		else
			echo "A lock file exists with a different PID.
Please check the status manually."
			exit 0
		fi
fi
echo "TNRastic is not running."