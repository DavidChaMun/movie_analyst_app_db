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
   mysql --defaults-extra-file='/temp.cnf' -silent < db_start.sql >> init_logs.txt 
}

LIM_E=0
MAX_I=10
while [[ ! mysql_ready || ! $LIM_E -gt $MAX_I  ]]
do
    sleep 3
    echo "waiting for mysql ..."
    LIM_E=$(( LIM_E + 1 ))
done

if ! [ $LIM_E == $MAX_I ]; then  
    rm db_start.sql
    rm temp.cnf
    rm init.sh

    echo "Initialization was a success, db ready for query!"
else
    echo "Initialization failed!"
fi


