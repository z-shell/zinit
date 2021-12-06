LOGPATH = doc/zsdoc/logs
LOGFILE = $(LOGPATH)/$(shell date --iso=seconds)

all: zinit.zsh.zwc zinit-side.zsh.zwc zinit-install.zsh.zwc zinit-autoload.zsh.zwc

%.zwc: %
	doc/zcompile $<

# Tests moved to gitlab-ci.
#alltest: test testB testC testD testE
#test:
#	make VERBOSE=$(VERBOSE) NODIFF=$(NODIFF) DEBUG=$(DEBUG) OPTDUMP=$(OPTDUMP) OPTS=$(OPTS) -C test test
#testB:
#	make VERBOSE=$(VERBOSE) NODIFF=$(NODIFF) DEBUG=$(DEBUG) OPTDUMP=$(OPTDUMP) OPTS="kshglob" -C test test
#testC:
#	make VERBOSE=$(VERBOSE) NODIFF=$(NODIFF) DEBUG=$(DEBUG) OPTDUMP=$(OPTDUMP) OPTS="noextendedglob" -C test test
#testD:
#	make VERBOSE=$(VERBOSE) NODIFF=$(NODIFF) DEBUG=$(DEBUG) OPTDUMP=$(OPTDUMP) OPTS="ksharrays" -C test test
#testE:
#	make VERBOSE=$(VERBOSE) NODIFF=$(NODIFF) DEBUG=$(DEBUG) OPTDUMP=$(OPTDUMP) OPTS="ignoreclosebraces" -C test test

doc: zinit.zsh zinit-side.zsh zinit-install.zsh zinit-autoload.zsh
	rm -rf doc/zsdoc/data doc/zsdoc/*.adoc
	cd doc && \
	zsd -v --scomm --cignore \
	'(\#*FUNCTION:*{{{*|\#[[:space:]]#}}}*)' \
	../zinit.zsh ../zinit-side.zsh ../zinit-install.zsh ../zinit-autoload.zsh
	echo $(LOGFILE)
	cd ..

html: doc
	cd doc/zsdoc && \
	asciidoctor zinit.zsh.adoc && \
	asciidoctor zinit-side.zsh.adoc && \
	asciidoctor zinit-install.zsh.adoc && \
	asciidoctor zinit-autoload.zsh.adoc
	echo $(LOGFILE)
	cd ..

clean:
	rm -f zinit.zsh.zwc zinit-side.zsh.zwc zinit-install.zsh.zwc zinit-autoload.zsh.zwc
	rm -rf doc/zsdoc/data

.PHONY: all clean doc

# vim:noet:sts=8:ts=8
