#!/bin/bash

# Start MySQL service
service mysql start && sleep 3

# Set root password and flush privileges
mysql -h localhost -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123'; FLUSH PRIVILEGES;"

# Check if the 'mgsv_server' database exists
DB_EXISTS=$(mysql -u root -p123 -sse "SHOW DATABASES LIKE 'mgsv_server'" | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
    echo "Database does not exist. Creating and importing data..."
    # Create the database
    mysql -u root -p123 -e "CREATE DATABASE mgsv_server;"

    # Import the database
    mysql -u root -p123 mgsv_server < /mgsv_server.dump.sql

    # Remove temporary SQL files
    rm /mgsv_server.dump.sql
else
    echo "Database already exists. Skipping database creation and import."
fi

# Start Apache
apachectl -D FOREGROUND
