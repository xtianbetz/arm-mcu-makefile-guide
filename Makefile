all: index.html

index.html: README.adoc
	asciidoc README.adoc
	mv README.html index.html

clean: index.html
	rm -f index.html

preview: index.html
	firefox index.html
