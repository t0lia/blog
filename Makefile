run:
	hugo server -D

update:
	pkill hugo || echo "hugo is not running"
	nohup hugo server --bind="0.0.0.0" --port=1312 --baseUrl=blog.apozdniakov.com --appendPort=false &

save:
	git add .
	git commit -m '-'
	git push
	ssh apozdniakov.com 'cd blog && git pull && make update'
