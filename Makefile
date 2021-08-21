.PHONY: deploy
deploy:
	rsync -r env.sh isucon@3.114.252.19:/home/isucon/
	rsync -r init.sh isucon@3.114.252.19:/home/isucon/
	rsync -r webapp/go/ isucon@3.114.252.19:/home/isucon/webapp/go/
	rsync --rsync-path="sudo rsync" -r etc isucon@3.114.252.19:/
	ssh isucon@3.114.252.19 "/home/isucon/init.sh"

.PHONY: deploy-mysql-s
deploy-mysql-s:
	rsync -r webapp/sql/ isucon@54.150.165.245:/home/isucon/webapp/sql/
	ssh isucon@54.150.165.245 "/home/isucon/webapp/sql/init.sh"
