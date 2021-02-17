source ../.env

docker exec -it database mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${WORDPRESS_MYSQL_USER}' IDENTIFIED BY '${WORDPRESS_MYSQL_PASSWORD}';"
docker exec -it database mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${WORDPRESS_MYSQL_DATABASE}.* TO '${WORDPRESS_MYSQL_USER}';"
