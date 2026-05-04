.PHONY: all html index clean distclean help check-deps install-deps

# ═══════════════════════════════════════════════════════════════════════════════
#   Clube de Matemática — Knowledge Base
#
#   .md  (guidelines/, techniques/, explanations/, core-knowledge/,
#          resources/, README.md)  →  pandoc    → HTML
#   .tex (solutions/, problems/)   →  make4ht   → HTML  (htlatex como fallback)
#
#   Dependências além do TeX Live existente: apenas pandoc.
# ═══════════════════════════════════════════════════════════════════════════════

DOCS_DIR   := docs
CSS_FILE   := $(DOCS_DIR)/style.css
INDEX_HTML := $(DOCS_DIR)/index.html

LATEX_PACKAGES = \
    inputenc lmodern fontenc geometry xcolor \
    amsmath amssymb amsthm mathtools \
    hyperref mdframed tcolorbox

LATEX_PACKAGE_FILES = $(addsuffix .sty,$(LATEX_PACKAGES))

# ─── Detecção de OS (mesmo padrão do Estatuto) ────────────────────────────────
ifeq ($(OS),Windows_NT)
    RM_DIR_CMD := rm -rf
    OS_NAME    := Windows
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        RM_DIR_CMD := rm -rf
        OS_NAME    := Linux
    else ifeq ($(UNAME_S),Darwin)
        RM_DIR_CMD := rm -rf
        OS_NAME    := macOS
    else
        RM_DIR_CMD := rm -rf
        OS_NAME    := Unknown
    endif
endif

# ─── Fontes ───────────────────────────────────────────────────────────────────
# .md: todo o repositório, exceto solutions/, problems/ e docs/
MD_SOURCES  := $(shell find . -name "*.md"    \
                  ! -path "*/solutions/*"      \
                  ! -path "*/problems/*"       \
                  ! -path "*/$(DOCS_DIR)/*"    \
                  | sed 's|^\./||' | sort)

# .tex: apenas dentro de solutions/ e problems/
TEX_SOURCES := $(shell find solutions problems \
                  -name "*.tex" 2>/dev/null    \
                  | sed 's|^\./||' | sort)

MD_TARGETS  := $(addprefix $(DOCS_DIR)/,$(MD_SOURCES:.md=.html))
TEX_TARGETS := $(addprefix $(DOCS_DIR)/,$(TEX_SOURCES:.tex=.html))

# ═══════════════════════════════════════════════════════════════════════════════

all: html

html: check-deps $(CSS_FILE) $(MD_TARGETS) $(TEX_TARGETS) $(INDEX_HTML)
	@echo "  ✓ Knowledge base gerado em $(DOCS_DIR)/"
	@echo "    .md  : $(words $(MD_TARGETS)) arquivo(s)"
	@echo "    .tex : $(words $(TEX_TARGETS)) arquivo(s)"

index: $(INDEX_HTML)

# ─── Verificação de dependências ──────────────────────────────────────────────
check-deps:
	@echo "Verificando dependências..."
	@command -v pandoc >/dev/null 2>&1 \
	    || { echo "ERRO: pandoc não encontrado. Execute 'make install-deps'."; exit 1; }
	@command -v kpsewhich >/dev/null 2>&1 \
	    || { echo "ERRO: kpsewhich não encontrado. A instalação do TeX está incompleta."; exit 1; }
	@{ command -v make4ht >/dev/null 2>&1 \
	   || command -v htlatex >/dev/null 2>&1; } \
	    || { echo "ERRO: make4ht/htlatex não encontrado. Instale texlive-full."; exit 1; }
	@missing=""; \
	for pkg in $(LATEX_PACKAGE_FILES); do \
	    if ! kpsewhich "$$pkg" >/dev/null 2>&1; then \
	        missing="$$missing $$pkg"; \
	    fi; \
	done; \
	if [ -n "$$missing" ]; then \
	    echo "ERRO: Pacotes LaTeX ausentes:$$missing"; \
	    echo "Execute 'make install-deps'."; \
	    exit 1; \
	fi
	@echo "  ✓ Todas as dependências OK!"

install-deps:
	@echo "=== Clube de Matemática — Instalação de dependências ($(OS_NAME)) ==="
	@echo ""
	@echo "  pandoc (única dep nova em relação ao Estatuto):"
	@echo "    Linux   : sudo apt install pandoc"
	@echo "    macOS   : brew install pandoc"
	@echo "    Windows : https://pandoc.org/installing.html"
	@echo ""
	@echo "  TeX Live / make4ht (já exigido pelo Estatuto):"
	@echo "    Linux   : sudo apt install texlive-full"
	@echo "    macOS   : brew install --cask mactex"
	@echo "    Windows : https://miktex.org"
	@echo ""
	@if command -v tlmgr >/dev/null 2>&1; then \
	    echo "  Tentando instalar pacotes LaTeX via tlmgr..."; \
	    tlmgr install $(LATEX_PACKAGES) || \
	        echo "  ATENÇÃO: se falhou no Linux, use o gerenciador da sua distro."; \
	elif command -v miktex >/dev/null 2>&1; then \
	    for pkg in $(LATEX_PACKAGES); do \
	        miktex packages install "$$pkg" || true; \
	    done; \
	else \
	    echo "  Nenhum gerenciador TeX encontrado. Instale manualmente."; \
	fi
	@echo "  ✓ Processo de instalação finalizado!"

# ─── CSS compartilhado (aplicado aos .md; os .tex geram o próprio) ────────────
$(CSS_FILE):
	@mkdir -p $(DOCS_DIR)
	@echo "Gerando stylesheet..."
	@printf '%s\n'                                                               \
	    ':root {'                                                                \
	    '    --bg:      #0f1117;'                                                \
	    '    --surface: #1a1d27;'                                                \
	    '    --border:  #2a2d3a;'                                                \
	    '    --text:    #e2e4ed;'                                                \
	    '    --muted:   #7a7d8a;'                                                \
	    '    --accent:  #7c9cff;'                                                \
	    '    --math:    #c3a6ff;'                                                \
	    '    --code-bg: #1e2130;'                                                \
	    '}'                                                                      \
	    '* { box-sizing: border-box; margin: 0; padding: 0; }'                  \
	    'body { font-family: Georgia, "Times New Roman", serif;'                 \
	    '       background: var(--bg); color: var(--text);'                     \
	    '       line-height: 1.75; max-width: 860px;'                           \
	    '       margin: 0 auto; padding: 2.5rem 2rem; }'                        \
	    'h1,h2,h3,h4 { font-family: "Palatino Linotype", Palatino, serif;'     \
	    '               color: var(--accent); margin: 2rem 0 .75rem; }'         \
	    'h1 { font-size: 2rem; border-bottom: 1px solid var(--border);'         \
	    '     padding-bottom: .5rem; }'                                          \
	    'h2 { font-size: 1.4rem; }'                                              \
	    'h3 { font-size: 1.15rem; color: var(--math); }'                        \
	    'a  { color: var(--accent); text-decoration: none; }'                   \
	    'a:hover { text-decoration: underline; }'                                \
	    'p  { margin: .75rem 0; }'                                               \
	    'code { font-family: "Fira Code", Consolas, monospace;'                 \
	    '       background: var(--code-bg); border: 1px solid var(--border);'   \
	    '       border-radius: 4px; padding: .1em .4em; font-size: .9em; }'     \
	    'pre  { background: var(--code-bg); border: 1px solid var(--border);'   \
	    '       border-radius: 6px; padding: 1rem;'                             \
	    '       overflow-x: auto; margin: 1rem 0; }'                            \
	    'pre code { border: none; background: none; padding: 0; }'              \
	    'blockquote { border-left: 3px solid var(--math);'                      \
	    '             padding-left: 1rem; color: var(--muted); margin: 1rem 0; }'\
	    'table { border-collapse: collapse; width: 100%; margin: 1rem 0; }'     \
	    'th    { background: var(--surface); color: var(--accent); }'           \
	    'th,td { border: 1px solid var(--border); padding: .5rem .75rem; }'     \
	    'hr    { border: none; border-top: 1px solid var(--border); margin: 2rem 0; }'\
	    > $@

# ─── MD → HTML (pandoc) ───────────────────────────────────────────────────────
$(DOCS_DIR)/%.html: %.md $(CSS_FILE)
	@mkdir -p $(dir $@)
	@echo "  [md]  $<"
	@DEPTH=$$(echo "$(dir $@)" | tr -cd '/' | wc -c); \
	REL_CSS=$$(python3 -c \
	    "import os; print(os.path.relpath('$(CSS_FILE)', '$(dir $@)'))" \
	    2>/dev/null || \
	    printf '../%.0s' $$(seq 1 $$(($$DEPTH - 1))) && printf 'style.css'); \
	pandoc "$<" -o "$@"                             \
	    --standalone                                 \
	    --metadata title="$(basename $(notdir $<))" \
	    --metadata lang=pt-BR                       \
	    --css="$$REL_CSS"

# ─── TEX → HTML (make4ht / htlatex — mesmo que o Estatuto) ───────────────────
$(DOCS_DIR)/%.html: %.tex
	@mkdir -p $(dir $@)
	@echo "  [tex] $<"
	@if command -v make4ht >/dev/null 2>&1; then           \
	    cd "$(dir $<)" &&                                   \
	    make4ht -d "$(abspath $(dir $@))" "$(notdir $<)";  \
	else                                                    \
	    cd "$(dir $<)" &&                                   \
	    htlatex "$(notdir $<)" "" "" ""                     \
	        "-d$(abspath $(dir $@))/";                      \
	fi
	@# Corrige encoding legado (mesmo tratamento do Estatuto)
	@if [ -f "$@" ] && file "$@" 2>/dev/null | grep -q "ISO-8859"; then \
	    iconv -f iso-8859-1 -t utf-8 "$@" -o "$@.tmp" && mv "$@.tmp" "$@"; \
	    sed -i 's/charset=iso-8859-1/charset=utf-8/g' "$@";               \
	fi

# ─── index.html navegável (shell puro — sem python3) ─────────────────────────
$(INDEX_HTML): $(MD_TARGETS) $(TEX_TARGETS) $(CSS_FILE)
	@echo "Gerando índice de navegação..."
	@{ \
	printf '<!DOCTYPE html>\n<html lang="pt-BR">\n<head>\n'; \
	printf '<meta charset="utf-8">\n'; \
	printf '<title>Knowledge Base — Clube de Matemática</title>\n'; \
	printf '<link rel="stylesheet" href="style.css">\n'; \
	printf '<style>\n'; \
	printf 'body{max-width:980px}\n'; \
	printf '.hero h1{font-size:2.4rem;border:none;padding:0}\n'; \
	printf '.hero p{color:var(--muted);margin:.25rem 0 0}\n'; \
	printf '.sec{margin-top:2.5rem;font-size:.75rem;font-family:monospace;\n'; \
	printf '     text-transform:uppercase;letter-spacing:.12em;\n'; \
	printf '     color:var(--muted);border-bottom:1px solid var(--border);\n'; \
	printf '     padding-bottom:.35rem}\n'; \
	printf '.grid{display:grid;\n'; \
	printf '      grid-template-columns:repeat(auto-fill,minmax(240px,1fr));\n'; \
	printf '      gap:1rem;margin:1rem 0 0}\n'; \
	printf '.card{background:var(--surface);border:1px solid var(--border);\n'; \
	printf '      border-radius:8px;padding:1.1rem 1.25rem}\n'; \
	printf '.card-t{font-size:.72rem;font-family:monospace;\n'; \
	printf '        text-transform:uppercase;letter-spacing:.1em;\n'; \
	printf '        color:var(--muted);margin-bottom:.6rem}\n'; \
	printf '.card ul{list-style:none}\n'; \
	printf '.card li{padding:.18rem 0;font-size:.88rem}\n'; \
	printf '.card a::before{content:"-> ";color:var(--border)}\n'; \
	printf '</style>\n</head>\n<body>\n'; \
	printf '<div class="hero"><h1>Knowledge Base</h1>'; \
	printf '<p>Clube de Matemática</p></div>\n'; \
	} > $@
	@# ── Seções simples (.md) ─────────────────────────────────────────────────
	@for section in guidelines techniques explanations core-knowledge resources; do \
	    dir="$(DOCS_DIR)/$$section"; \
	    [ -d "$$dir" ] || continue; \
	    files=$$(find "$$dir" -name "*.html" ! -name "index.html" 2>/dev/null | sort); \
	    [ -n "$$files" ] || continue; \
	    printf '<p class="sec">%s</p><div class="grid"><div class="card">\n' \
	        "$$section" >> $@; \
	    printf '<p class="card-t">%s</p><ul>\n' "$$section" >> $@; \
	    echo "$$files" | while IFS= read -r f; do \
	        rel="$${f#$(DOCS_DIR)/}"; \
	        label="$$(basename "$$f" .html)"; \
	        printf '  <li><a href="%s">%s</a></li>\n' "$$rel" "$$label" >> $@; \
	    done; \
	    printf '</ul></div></div>\n' >> $@; \
	done
	@# ── Seções com subpastas (.tex) ──────────────────────────────────────────
	@for section in solutions problems; do \
	    dir="$(DOCS_DIR)/$$section"; \
	    [ -d "$$dir" ] || continue; \
	    printf '<p class="sec">%s</p><div class="grid">\n' "$$section" >> $@; \
	    for sub in logic discrete-math algebra probability algorithm; do \
	        subdir="$$dir/$$sub"; \
	        [ -d "$$subdir" ] || continue; \
	        files=$$(find "$$subdir" -name "*.html" ! -name "index.html" 2>/dev/null | sort); \
	        [ -n "$$files" ] || continue; \
	        printf '<div class="card"><p class="card-t">%s</p><ul>\n' "$$sub" >> $@; \
	        echo "$$files" | while IFS= read -r f; do \
	            rel="$${f#$(DOCS_DIR)/}"; \
	            label="$$(basename "$$f" .html)"; \
	            printf '  <li><a href="%s">%s</a></li>\n' "$$rel" "$$label" >> $@; \
	        done; \
	        printf '</ul></div>\n' >> $@; \
	    done; \
	    printf '</div>\n' >> $@; \
	done
	@# ── README ───────────────────────────────────────────────────────────────
	@[ -f "$(DOCS_DIR)/README.html" ] && \
	    printf '<p class="sec">readme</p><p><a href="README.html">README</a></p>\n' \
	    >> $@ || true
	@printf '</body></html>\n' >> $@
	@echo "  ✓ $(INDEX_HTML)"

# ─── Limpeza ──────────────────────────────────────────────────────────────────
clean:
	@echo "Removendo $(DOCS_DIR)/..."
	@$(RM_DIR_CMD) $(DOCS_DIR)
	@echo "  ✓ Tudo limpo."

distclean: clean

# ─── Ajuda ────────────────────────────────────────────────────────────────────
help:
	@echo "=== Clube de Matemática — Knowledge Base ==="
	@echo ""
	@echo "  Sistema operacional : $(OS_NAME)"
	@echo "  Saída               : $(DOCS_DIR)/"
	@echo "  Fontes .md          : $(words $(MD_SOURCES)) arquivo(s)"
	@echo "  Fontes .tex         : $(words $(TEX_SOURCES)) arquivo(s)"
	@echo ""
	@echo "Targets:"
	@echo "  make              Converte tudo e gera o índice"
	@echo "  make index        Regenera apenas o índice"
	@echo "  make check-deps   Verifica dependências"
	@echo "  make install-deps Instala dependências"
	@echo "  make clean        Remove $(DOCS_DIR)/"
	@echo "  make help         Exibe esta mensagem"
	@echo ""
	@echo "Uso típico (primeira vez):"
	@echo "  make install-deps && make"
	@echo ""
	@echo "Dependência nova em relação ao Estatuto:"
	@echo "  pandoc  — converte .md → HTML"
