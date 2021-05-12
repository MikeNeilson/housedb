#/bin/sh
echo "Checking if existing installation or new."
systemctl status housedb-api | grep "Loaded:" | grep ": loaded"
if [ $? -eq 0 ]; then
    echo "Restarting restarting service and reseting to link in /lib/systemd/system"    
    systemctl stop housedb-api
    systemctl disable housedb-api    
    systemctl deamon-reload
    systemctl enable housedb-api
    systemctl start housedb-api
    if [ $? -ne 0 ]; then
        echo "failed to restart service. please check on it"
    fi
    exit 0
else
    echo "You must set the Following environment variables on the service before enabling"
    echo "use \"systemctl edit housedb-api\""
    echo "Environment=\"HOUSEDB_LISTEN_ADDRESS=0.0.0.0\""
    echo "Environment=\"HOUSEDB_PORT=7000\""
    echo "Environment=\"HOUSEDB_URL=jdbc:postgresql://<host>:<port>/<db name>\""
    echo "Environment=\"HOUSEDB_USERNAME=housedb_user\""
    echo "Environment=\"HOUSEDB_PASSWORD=<the actual password>\""
fi
exit 0