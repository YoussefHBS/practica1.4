#!/bin/bash

#  Configuramos el script para que se muestren los comandos
# y finalice cuando hay un error en la ejecución

set -ex

# Importamos el archivo .env
source .env
# Creamos el certificado autofirmado
sudo openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

#   Copiamos el archivo de configuración de apache con SSL/TLS

cp ../conf/default-ssl.conf /etc/apache2/sites-available

#  Habilitamos el nuevo virtualHost para ssl/tls
a2ensite default-ssl.conf

#  Habilitamos el mopdulo ssl/tls de apache
a2enmod  ssl

# Habilitamos el módulo de reescritura de URLs
a2enmod rewrite

# Copiamos el archivo de configuración de Apache para HTTP
cp ../conf/000-default.conf /etc/apache2/sites-available

#  Habilitamos el nuevo virtualHost para HTTP
a2ensite 000-default.conf

# Reiniciamos el servidor apache2
systemctl restart apache2