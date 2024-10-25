#!/bin/bash

#  Configuramos el script para que se muestren los comandos
# y finalice cuando hay un error en la ejecución

set -ex

# Importamos el archivo .env
source .env

# eliminamos clonadas previas del repositorio
rm -rf /tmp/iaw-practica-lamp

# Clonamos el repositorio de la aplicacion en /tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# Movemos el codigó fuente del directorio src al directorio /var/www/html
mv /tmp/iaw-practica-lamp/src/* /var/www/html

# creamos una base de datos para la aplicación
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME"

# Creamos un usuario  para la base de datos anterior
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"

# Configuramos el archivo config.php
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

# Configuramos el archivo database.sql
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql

# Ejecutamos  el script de SQL para crear las tablas
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql