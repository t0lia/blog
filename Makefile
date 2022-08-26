run:
	hugo server -D

save:
	git add .
	git commit -m '-'
	git push
	ssh apozdniakov.com 'cd blog && make update'
