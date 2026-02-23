TYP_FILES := $(shell find content -name '*.typ' -not -path '*/_*')

HTML_FILES := $(patsubst content/%.typ,docs/%.html,$(TYP_FILES))

BLOG_FILES := $(wildcard content/blog/*/index.typ)

html: $(HTML_FILES) assets

docs/%.html: content/%.typ
	@mkdir -p $(@D)
	typst compile --root . --features html --format html $< $@
docs/blog/index.html: index.json content/blog/index.typ
	mkdir -p docs/blog
	typst compile --root . --features html --format html content/blog/index.typ $@

index.json:$(BLOG_FILES)
	for POST in $(BLOG_FILES); do \
		POST_DIR="$$(basename $$(dirname $$POST))"; \
		typst query --root . --features html --one $$POST '<post-metadata>' | \
			jq ".value + {\"path\": \"$$POST_DIR\"}"; \
	done | jq -s "." > $@

assets:
	@mkdir -p docs/assets
	@cp -r assets/* docs/assets/

clean:
	rm -f index.json
	rm -rf docs/*

.PHONY: html clean assets
