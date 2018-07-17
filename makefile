.env:
	@read -p "MYSQL_ROOT_PASSWORD: " MYSQL_ROOT_PASSWORD; \
	read -p "MYSQL_DATABASE: " MYSQL_DATABASE; \
	read -p "MYSQL_USER: " MYSQL_USER; \
	read -p "MYSQL_PASSWORD: " MYSQL_PASSWORD; \
	echo -e MYSQL_ROOT_PASSWORD=$$MYSQL_ROOT_PASSWORD >> .env; \
	echo -e MYSQL_DATABASE=$$MYSQL_DATABASE >> .env; \
	echo -e MYSQL_USER=$$MYSQL_USER >> .env; \
	echo -e MYSQL_PASSWORD=$$MYSQL_PASSWORD >> .env
stack: .env
	@read -p "Enter Stack Name: " stack; \
	source ./.env; \
	MYSQL_ROOT_PASSWORD=$$MYSQL_ROOT_PASSWORD \
	MYSQL_DATABASE=$$MYSQL_DATABASE \
	MYSQL_USER=$$MYSQL_USER \
	MYSQL_PASSWORD=$$MYSQL_PASSWORD \
	docker stack deploy --compose-file=docker-compose.yml $$stack
up: .env
	docker-compose up -d
create:
	docker create -v /var/lib/mysql --name mariadb-data alpine:latest /bin/true
	docker create -v /var/www/html/wp-content --name 2994a43e8c87 alpine:latest /bin/true
backup:
	docker run --rm --volumes-from mariadb-data -v ${PWD}:/backup alpine:latest tar cvf /backup/mysql.tar /var/lib/mysql
	docker run --rm --volumes-from 2994a43e8c87 -v ${PWD}:/backup alpine:latest tar cvf /backup/wp-content.tar /var/www/html/wp-content
restore:
	docker run --rm --volumes-from mariadb-data -v ${PWD}:/backup alpine:latest /bin/sh -c "cd / && tar xvf /backup/mysql.tar"
	docker run --rm --volumes-from 2994a43e8c87 -v ${PWD}:/backup alpine:latest /bin/sh -c "cd / && tar xvf /backup/wp-content.tar"
