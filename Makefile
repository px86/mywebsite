site:
	emacs -Q --script ./build-site.el

copy:
	cp -r site-content/assets public/

server:
	python3 -m http.server --directory ./public/

clean:
	rm -rf public
