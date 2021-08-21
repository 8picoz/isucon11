.PHONY: deploy
deploy:
	rsync -r env.sh isucon@3.114.252.19:/home/isucon/
	rsync -r init.sh isucon@3.114.252.19:/home/isucon/
	rsync -r webapp/go/ isucon@3.114.252.19:/home/isucon/webapp/go/
	rsync --rsync-path="sudo rsync" -r etc/nginx isucon@3.114.252.19:/etc
	rsync --rsync-path="sudo rsync" -r etc/mysql isucon@3.114.252.19:/etc
	ssh isucon@3.114.252.19 "/home/isucon/init.sh"
