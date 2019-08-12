docker exec -it database mysql -u root -pabcxyz -e "CREATE USER 'wordpress-user' IDENTIFIED BY 'eternity-radix-veldt-dropkick1';"
docker exec -it database mysql -u root -pabcxyz -e "CREATE DATABASE wordpress;"
docker exec -it database mysql -u root -pabcxyz -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress-user';"


