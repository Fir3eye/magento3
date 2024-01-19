#!/bin/sh

set -e

# Run Magento setup command
php -dmemory_limit=-1 bin/magento setup:install --base-url=http://${SERVER_IP}:8080/ --db-host=db --db-name=magentodb --db-user=magentouser --db-password=MyPassword --admin-firstname=Admin --admin-lastname=User --admin-email=admin@your-domain.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1  --backend-frontname="admin" --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200 --elasticsearch-index-prefix=magento2 --elasticsearch-enable-auth=0 --elasticsearch-timeout=15 

# Upgrade
php -dmemory_limit=-1 bin/magento setup:upgrade

chmod -R 777 /var/www/html/var
chmod -R 777 /var/www/html/generated
chmod -R 777 /var/www/html/vendor
# Start Apache (or your web server) in the foreground
exec apache2-foreground
