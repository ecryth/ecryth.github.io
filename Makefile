TYP_FILES := $(shell find content -name '*.typ' -not -path '*/_*')

HTML_FILES := $(patsubst content/%.typ,_site/%.html,$(TYP_FILES))

BLOG_FILES := $(wildcard content/blog/*/index.typ)

html: $(HTML_FILES) assets

_site/%.html: content/%.typ
	@mkdir -p $(@D)
	typst compile --root . --features html --format html $< $@
_site/blog/index.html: index.json content/blog/index.typ
	mkdir -p _site/blog
	typst compile --root . --features html --format html content/blog/index.typ $@

index.json:$(BLOG_FILES)
	for POST in $(BLOG_FILES); do \
		POST_DIR="$$(basename $$(dirname $$POST))"; \
		typst query --root . --features html --one $$POST '<post-metadata>' | \
			jq ".value + {\"path\": \"$$POST_DIR\"}"; \
	done | jq -s "." > $@

assets:
	@mkdir -p _site/assets
	@cp -r assets/* _site/assets/

clean:
	rm -f index.json
	rm -rf _site/*

.PHONY: html clean assets
