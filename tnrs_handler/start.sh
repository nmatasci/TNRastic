#! /bin/env bash
if [ -e ".tnrs_handler.pid" ]; then
		OPID=$(cat .tnrs_handler.pid)
		
		if ps aux | sed -r 's/\s+/\t/g' |cut -f 2 | grep ${OPID} 1> /dev/null; then
			echo "Another instance of TNRastic might be running. Please stop that instance before continuing"
			exit 0
		else 
			rm .tnrs_handler.pid
		fi
fi

cd bin
perl tnrs_handler.pl --environment=production_test &

echo "TNRastic successfully started"
