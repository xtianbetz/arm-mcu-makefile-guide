all: index.html README.md

index.html: README.adoc
	asciidoctor README.adoc
	mv README.html index.html

README.xml: README.adoc
	asciidoctor -b docbook README.adoc

README.md: README.xml
	pandoc -f docbook -t markdown_strict README.xml -o README.md

clean:
	rm -f index.html README.md README.xml

show-preview: index.html
	firefox index.html

reload-preview: index.html
	reload-firefox

