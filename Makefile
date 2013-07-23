VERSION := 1.0.1

love:
	@echo "Feel like makin' love."

pack:
	zip -r "vim-bbye-$(VERSION).zip" * --exclude Makefile --exclude "*.zip"

publish:
	open "http://www.vim.org/scripts/add_script_version.php?script_id=4664"

tag:
	git tag "v$(VERSION)"
	
.PHONY: love pack publish tag
