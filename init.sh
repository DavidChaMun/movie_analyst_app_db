#!/bin/bash
touch init_logs.txt

echo 'creating temp.cnf' >> init_logs.txt
touch temp.cnf >> init_logs.txt

echo 'populated cnf' >> init_logs.txt
echo '[client]' >> temp.cnf
echo 'user=root' >> temp.cnf
echo 'password='$MYSQL_ROOT_PASSWORD >> temp.cnf
echo 'password='$MYSQL_ROOT_PASSWORD >> init_logs.txt


# Returns true once mysql can connect.
mysql_ready() {
   mysql --defaults-extra-file='/temp.cnf' < db_start.sql >> init_logs.txt 
}

LIM_E=0
MAX_I=30
echo ""
echo -n "waiting for mysql ..."
while [ ! $LIM_E -gt $MAX_I  ]
do
    mysql --defaults-extra-file='/temp.cnf' < db_start.sql >> init_logs.txt 2>&1
    if [ $? -eq 0 ]; then
        echo "Success"
        break;
    fi
    sleep 2
    echo -n "."
    LIM_E=$(( LIM_E + 1 ))
done

if ! [ $LIM_E -ge $MAX_I ]; then  
    echo "Initialization was a success, db ready for query!"
else
    echo "Initialization failed!, tries=$LIM_E"
    exit 1
fi


