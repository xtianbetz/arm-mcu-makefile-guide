all: index.html README.md

index.html: README.adoc
#	asciidoc README.adoc
	asciidoctor README.adoc
	mv README.html index.html

README.md: README.adoc
#	asciidoc -b docbook README.adoc
	asciidoctor -b docbook README.adoc
	pandoc -f docbook -t markdown_strict README.xml -o README.md

clean:
	rm -f index.html README.md

preview: index.html
	firefox index.html
