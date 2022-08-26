run:
	hugo server -D

update:
	kill -9 $(cat /tmp/hugo.pid)
	nohup hugo server --bind="0.0.0.0" --port=1312 --baseUrl=blog.apozdniakov.com --appendPort=false &
	echo $! >/tmp/hugo.pid

save:
	git add .
	git commit -m '-'
	git push
	ssh apozdniakov.com 'cd blog && git pull && make update'
