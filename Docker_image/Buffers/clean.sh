sed -i "2 s/.*.*/CREATE USER 'placeholder'@'%' IDENTIFIED BY 'placeholder';/" db_start.sql
sed -i "3 s/.*.*/GRANT SELECT ON movie_db.* TO 'placeholder';/" db_start.sql 
