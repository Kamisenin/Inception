RED='\033[0;31m'
Green='\033[0;32m'
NC='\033[0m'

echo "Generating MariaDB configuration..."

: "${MYSQL_ROOT_PASSWORD:?You have to define MYSQL_ROOT_PASSWORD}"
: "${WORDPRESS_DB:=wordpress}"
: "${WORDPRESS_USER:=wpuser}"
: "${WORDPRESS_PASSWORD:?You have To Define WORDPRESS_PASSWORD}"

if [ -d "/var/lib/mysql/mysql"]; then
    
    echo "${RED}MariaDB already configured...${NC}"
    
else
SQL_FILE="/tmp/commandline"
cat > "$SQL_FILE" << SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS `${WORDPRESS_DB}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';
GRANT ALL PRIVILEGES ON `${WORDPRESS_DB}`.* TO '${WORDPRESS_USER}'@'%';
FLUSH PRIVILEGES;
SQL

mariadb --user=mysql --datadir=/var/lib/mysql --bootstrap < "$SQL_FILE"
rm -f "$SQL_FILE"
fi

echo "${Green}Starting MariaDB...${NC}"