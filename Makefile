.PHONY: deploy
deploy:
	rsync -r webapp/go/ isucon@3.114.252.19:/home/isucon/webapp/
	ssh isucon@3.114.252.19 "cd /home/isucon/webapp/go && rm -r ./isucondition && make build && make && sudo systemctl restart isucondition.go.service"
