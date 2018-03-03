NAME := bbye
VERSION := 1.0.1
ID := 4664

love:
	@echo "Feel like makin' love."

pack:
	zip -r "$(NAME)-$(VERSION).zip" * --exclude Makefile --exclude "*.zip"

publish:
	open "http://www.vim.org/scripts/add_script_version.php?script_id=$(ID)"

tag:
	git tag "v$(VERSION)"
	
.PHONY: love pack publish tag
