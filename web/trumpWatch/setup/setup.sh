#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

set -x

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'
apt-get install apache2 php mysql-server php-mysql libapache2-mod-php php-bcmath -y

export MYSQL_USER=root
export MYSQL_PASS=93b2109eb1ec9448cf7c4feea1ecab0cbff43ced9a404e7baaf67621b0a0

export DEBIAN_FRONTEND="noninteractive"
echo "mysql-server mysql-server/root_password password $MYSQL_PASS" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_PASS" | sudo debconf-set-selections


mkdir /var/www/html
rm /var/www/html/index.html

cp -r html/* /var/www/html/.

cat html/database.sql | mysql -u root -p93b2109eb1ec9448cf7c4feea1ecab0cbff43ced9a404e7baaf67621b0a0
cat mysql | mysql -u root -p93b2109eb1ec9448cf7c4feea1ecab0cbff43ced9a404e7baaf67621b0a0

chmod -R go-r /etc/apache2
chmod -R go-w /var/www/html

cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ErrorLog \${APACHE_LOG_DIR}/trump_error.log
    CustomLog \${APACHE_LOG_DIR}/trump_access.log combined

    SetEnv MYSQL_USER $MYSQL_USER
    SetEnv MYSQL_PASS $MYSQL_PASS
    SetEnv CAPTCHA_SECRET 6LfZhAoUAAAAAMMI-l-bkSaMx_VaWfOt0ZN_90pF
    SetEnv FLAG flag{n0t_s0_r4nd0m_4ft3r_all_m4yb3_php_n33ds_t0_get_w1th_th3_t1mes}

    <Directory "/var/www/html">
        Options -Indexes
    </Directory>

</VirtualHost>
EOF

service apache2 restart
