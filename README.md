## 📢 First of All Clone the Repo in your machine 
```
git clone https://github.com/Fir3eye/magento3.git
```
## 🥏Go to app directory
```
cd magento3
```
## 🎰Build the image
```
docker build -t my-image-name .
```
**💎If you want to tag the image use below command**
```
docker tag -f my-image-name fir3eye/magento:v10
```
## 🎰Run
```
docker-compose up -d
```
## 🕹️Stop
```
docker-compose down --volume
```
---
## 🚫Errors
**when face symlink problem in magento use below command**
1. 🪜Run these command step-by-step
```
docker ps -a # show the container id
```
```
docker exec -it <container id> bash
```

```
php -dmemory_limit=-1 bin/magento setup:upgrade
```
---
## 🚀Give the Permissions
```
cd /var/www/html
chmod -R 777 var/www/html/vendor
chmod -R 777 /var/www/html/var
chmod -r 777 /var/www/html/generated
```

## This is only for Testing 

## 🕹️ You Can face the Problem while github action Pipeline Use below command 
```
sudo chown -R ubuntu:ubuntu /var/www/html
```
```
sudo usermod -aG docker ubuntu
```
