## Backend Cotainer 
```
docker run -d --name mysql -v mysql-data:/var/lib/mysql -v ./dbfile/dump.sql:/docker-entrypoint-initdb.d/dump.sql --network=twotier -e MYSQL_DATABASE=magentodb -e MYSQL_USER=magentouser -e MYSQL_ROOT_PASSWORD="admin" -p 3306:3306 dockt35t/mysql:latest
```
```
docker run -d --name mysql --network=twotier -e MYSQL_DATABASE=magentodb -e MYSQL_USER=magentouser -e MYSQL_ROOT_PASSWORD="admin" -p 3306:3306 mysql:5.7
```
## FrontEnd Container

```
docker run -d --name magento -v mysql-data:/var/lib/mysql -v ./dbfile/dump.sql:/docker-entrypoint-initdb.d/dump.sql --network=twotier -e MYSQL_DATABASE=magentodb -e MYSQL_USER=magentouser -e MYSQL_ROOT_PASSWORD="admin" -p 8080:80 -p 8443:443 dockt35t/magento:latest
```
```
docker run -d --name magento --network=twotier -e MYSQL_DATABASE=magentodb -e MYSQL_USER=magentouser -e MYSQL_ROOT_PASSWORD="admin" -p 8080:80 -p 9200:9200 -p 443:8443 dockt35t/magento:latest
```
## Give the Permissoin

```
cd ..
chmod -R 755 html/
```
## Go to html directory
```
cd html
chmod -R 777 app/etc/
chmod -R 777 var/
chmod -r 777 pub/
chmod -R 777 generated/
```
