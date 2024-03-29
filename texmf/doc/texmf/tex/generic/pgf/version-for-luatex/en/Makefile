rerun = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
doc   = pgfmanual
latex = lualatex
luadoc = luadoc --doclet luadoc.doclet.tex -t "luadoc/doclet/tex" --taglet luadoc.taglet.pgfmanual -d ../../text-en/generated
TEXINPUTS := ../../text-en:../../images:$(TEXINPUTS)
LUA_PATH := ./luadoc/?.lua:$LUA_PATH

all: $(doc).pdf

# make dist will also enable automatic cross references in codeexamples.
# This is disabled by default as it requires higher mem limits.
#
# It employs a 'texmf.cnf' which lies in ../../text-en.
dist: FORCE
	export TEXMFCNF="../../text-en:$(TEXMFCNF)"; \
	export TEXINPUTS="$(TEXINPUTS)"; \
	$(latex) --jobname=pgfmanual '\def\pgfautoxrefs{1}\pdfminorversion=5 \pdfobjcompresslevel=2 \input{$(doc)}'
	makeindex $(doc).idx
	@echo "$(doc).pdf remade with auto-xref support. Check if auto-xrefs work and rerun make dist if not."

pgfmanual.idx: 
	touch pgfmanual.idx

pgfmanual.ind: pgfmanual.idx 
	makeindex $(doc).idx

pgfmanual.pdf: $(doc).tex $(doc).ind 
	TEXINPUTS="$(TEXINPUTS)" $(latex) $(doc).tex
	(egrep -q $(rerun) $(doc).log && TEXINPUTS="$(TEXINPUTS)" $(latex) $(doc).tex) || true
	@echo "Use 'make dist' to generate auto-xrefs."

genluadoc:
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-box.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-edge.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-graph.lua 
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-interface.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-iter.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-node.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-path.lua 
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-string.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-sys.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-table.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-texboxregister.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-traversal.lua
	$(luadoc) ../../../../../generic/pgf/libraries/graphdrawing/lua/pgflibrarygraphdrawing-vector.lua

FORCE:

clean:
	rm -f  \
		plots/* \
		pgfmanual.out \
		pgfmanual.log \
		pgfmanual.idx \
		pgfmanual.ind \
		pgfmanual.ilg \
		pgfmanual.pdf \
		pgfmanual.toc \
		pgfmanual.bbl \
		pgfmanual.blg \
		pgfmanual.ps \
		pgfmanual.dvi \
		pgfmanual*.aux 
