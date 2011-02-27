#!/bin/bash

# ---------------------------------------------------------------------------- #
# LAMP                                                                         #
# ---------------------------------------------------------------------------- #

echo "install Apache"
yes | sudo aptitude install apache2 apache2-mpm-prefork apache2-prefork-dev apache2-utils apache2.2-common

echo "install MySQL"
yes | sudo aptitude install mysql-server-5.1 mysql-client-5.1 libmysqlclient16-dev

echo "install PHP"
yes | sudo aptitude install php5 php5-xdebug php5-suhosin php5-mysql php5-gd libapache2-mod-php5

