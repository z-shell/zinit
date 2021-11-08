wiki: docs/*.md docs/css/*.css
	mkdocs build -d wiki

gh-pages: wiki
	mv -vf wiki wiki_
	git checkout gh-pages
	rm -rf wiki
	mv -vf wiki_ wiki
	git add -A wiki
	echo "Site build ["`date "+%m/%d/%Y %H:%M:%S"`"]" > .git/COMMIT_EDITMSG_
	cat .git/COMMIT_EDITMSG_
	git commit -F .git/COMMIT_EDITMSG_ && git push -f origin gh-pages

main: wiki
	git checkout main
