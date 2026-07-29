-- t2t_format.lua
-- txt2tags AND Markdown formatting helpers, wired to the right-click context menu.
-- The syntax used (txt2tags or Markdown) is auto-detected per buffer: see
-- is_markdown() below.
--
-- Loading (add to your startup script):
--   dofile(props["SciteUserHome"] .. "/.scite/t2t_format.lua")
--
-- Tools-menu / context-menu commands (add to your .properties file):
--   command.name.20.*.t2t;*.txt;*.md=Titre 1
--   command.20.*.t2t;*.txt;*.md=T2THeading1
--   command.mode.20.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   command.name.21.*.t2t;*.txt;*.md=Titre 2
--   command.21.*.t2t;*.txt;*.md=T2THeading2
--   command.mode.21.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   command.name.22.*.t2t;*.txt;*.md=Titre 3
--   command.22.*.t2t;*.txt;*.md=T2THeading3
--   command.mode.22.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   command.name.23.*.t2t;*.txt;*.md=Gras
--   command.23.*.t2t;*.txt;*.md=T2TBold
--   command.mode.23.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   command.name.24.*.t2t;*.txt;*.md=Italique
--   command.24.*.t2t;*.txt;*.md=T2TItalic
--   command.mode.24.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   command.name.25.*.t2t;*.txt;*.md=Souligné
--   command.25.*.t2t;*.txt;*.md=T2TUnderline
--   command.mode.25.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   command.name.26.*.t2t;*.txt;*.md=Barré
--   command.26.*.t2t;*.txt;*.md=T2TStrike
--   command.mode.26.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no
--
--   -- IDM_TOOLS(1100) + N gives the context-menu command id for command.name.N.*
--   -- Toujours inconditionnel : voir CLAUDE.md pour pourquoi un if/match ne marche pas ici.
--   user.context.menu=Titre 1|1120|Titre 2|1121|Titre 3|1122|||Gras|1123|Italique|1124|Souligné|1125|Barré|1126

-- Modern Scintilla lexers are set via SetILexer (named), not the legacy
-- numeric SetLexer -- editor.Lexer (SCI_GETLEXER) does not reflect them and
-- reads back 0. Use editor.LexerLanguage (string, always accurate) instead.

-- true when the current buffer uses Markdown syntax rather than txt2tags.
-- Lexer check first (works even if the extension was overridden by hand),
-- extension as a fallback (e.g. lexer not wired up for *.md yet).
local function is_markdown()
    if editor.LexerLanguage == "markdown" then return true end
    if editor.LexerLanguage == "txt2tags" then return false end
    local ext = (props["FileExt"] or ""):lower()
    return ext == "md" or ext == "markdown"
end

-- ── Inline marks (bold/italic/underline/strike) ────────────────────────────────

-- Wrap the selection in open/close, or strip them if the selection is
-- already wrapped (toggle). With no selection, insert an empty pair and
-- place the caret between the marks. close defaults to open (symmetric marks).
local function wrap_or_toggle(open, close)
    close = close or open
    local sel = editor:GetSelText()
    local olen, clen = #open, #close

    if sel == "" then
        local pos = editor.CurrentPos
        editor:ReplaceSel(open .. close)
        editor:GotoPos(pos + olen)
        return
    end

    if #sel >= olen + clen and sel:sub(1, olen) == open and sel:sub(-clen) == close then
        editor:ReplaceSel(sel:sub(olen + 1, -clen - 1))
    else
        editor:ReplaceSel(open .. sel .. close)
    end
end

function T2TBold() wrap_or_toggle("**") end -- identique en txt2tags et Markdown

function T2TItalic()
    if is_markdown() then wrap_or_toggle("*") else wrap_or_toggle("//") end
end

function T2TUnderline()
    -- Markdown n'a pas de syntaxe native pour le souligné (__ = gras en Markdown).
    if is_markdown() then wrap_or_toggle("<u>", "</u>") else wrap_or_toggle("__") end
end

function T2TStrike()
    if is_markdown() then wrap_or_toggle("~~") else wrap_or_toggle("--") end
end

-- ── Headings ─────────────────────────────────────────────────────────────────

-- Title for the current heading: the selection when there is one (single
-- line only), otherwise the current line's text with existing markers
-- stripped (symmetric "= x =" in txt2tags, leading "#..." in Markdown).
local function heading_title(line, md)
    local sel = editor:GetSelText()
    if sel ~= "" and not sel:find("[\r\n]") then
        return sel:match("^%s*(.-)%s*$")
    end
    local title
    if md then
        title = line:match("^#+%s*(.-)%s*$") or line
    else
        title = line:match("^=+%s*(.-)%s*=+%s*$") or line
    end
    title = title:match("^%s*(.-)%s*$")
    if title == "" then title = "Titre" end
    return title
end

-- Turn the current line into a heading: "# Title" (Markdown) or a symmetric
-- "= Title =" (txt2tags), replacing the whole line.
local function set_heading(level)
    local md      = is_markdown()
    local line_n  = editor:LineFromPosition(editor.CurrentPos)
    local line    = (editor:GetLine(line_n) or ""):gsub("[\r\n]+$", "")
    local title   = heading_title(line, md)

    local text
    if md then
        text = string.rep("#", level) .. " " .. title
    else
        local sym = string.rep("=", level)
        text = sym .. " " .. title .. " " .. sym
    end

    local line_s = editor:PositionFromLine(line_n)
    local line_e = line_s + #line
    editor:SetSel(line_s, line_e)
    editor:ReplaceSel(text)
end

function T2THeading1() set_heading(1) end
function T2THeading2() set_heading(2) end
function T2THeading3() set_heading(3) end

-- ── Correctif : heading non reconnu en toute première ligne ────────────────
--
-- Bug du lexer Scintilla txt2tags (LexTxt2tags.cxx) : à la position 0 du
-- document, l'état de départ est toujours SCE_TXT2TAGS_DEFAULT au lieu de
-- SCE_TXT2TAGS_LINE_BEGIN — le seul état où un "=" en tête de ligne déclenche
-- la coloration d'un heading. Après un saut de ligne, l'état repasse bien à
-- LINE_BEGIN, donc seule la toute première ligne du fichier est affectée.
-- C'est un bug du lexer C++ compilé dans SciTE : impossible à corriger côté
-- Lua autrement qu'en ré-appliquant nous-mêmes le style — purement cosmétique,
-- ça ne touche pas le contenu du fichier ni le rendu txt2tags réel.
--
-- Piège : editor:SetStyling() sur un vrai lexer (pas SCLEX_CONTAINER) est
-- écrasé par le prochain repaint — Scintilla ré-invoque son propre lexer et
-- écrase notre style. Pas de cache : on ré-applique donc à CHAQUE OnUpdateUI
-- (fréquent : frappe, déplacement du curseur, scroll...) pour gagner la
-- course à chaque fois plutôt qu'une seule fois. Coût négligeable (une seule
-- ligne relue et un motif simple), mais nécessaire pour que ça tienne visuellement.
local SCE_TXT2TAGS_HEADER1 = 6  -- HEADER1..HEADER6 = styles 6..11

local function fix_t2t_first_line_heading()
    if editor.LexerLanguage ~= "txt2tags" then return end

    local raw = editor:GetLine(0) or ""
    local line = raw:gsub("[\r\n]+$", "")
    local markers, rest = line:match("^(=+)(.*)$")
    if not markers or #markers > 6 then return end
    -- "=." + espace = liste, pas un heading (même exception que le lexer natif)
    if #markers == 1 and rest:match("^%.%s") then return end

    -- editor.StyleAt[0] a été essayé pour éviter de restyler quand ce n'est
    -- pas nécessaire, mais le style à la position 0 revient systématiquement
    -- à 0 (DEFAULT) entre deux OnUpdateUI (repaint réel du vrai lexer entre
    -- les deux) : le test ne fait qu'ajouter un appel sans jamais éviter le
    -- restyle. Mesuré (voir CLAUDE.md) : ~1 ms par OnUpdateUI, négligeable.
    editor:StartStyling(0, 0)
    editor:SetStyling(#line, SCE_TXT2TAGS_HEADER1 + #markers - 1)
end

local _prev_OnUpdateUI_t2tfmt = OnUpdateUI
function OnUpdateUI()
    fix_t2t_first_line_heading()
    if _prev_OnUpdateUI_t2tfmt then return _prev_OnUpdateUI_t2tfmt() end
end

-- ── Continuation automatique des listes ("- ") ──────────────────────────────
--
-- À la validation d'une ligne "<indent>- texte" (Entrée), la ligne suivante
-- démarre avec le même marqueur "- " (même syntaxe en txt2tags et Markdown,
-- pas de branchement is_markdown() nécessaire ici). Si la ligne validée est
-- un item de liste VIDE (juste "- ", sans texte : l'utilisateur a appuyé sur
-- Entrée deux fois de suite sans rien taper), le marqueur est retiré de cette
-- ligne au lieu d'être reporté : ça arrête la liste plutôt que de produire un
-- item vide en plus.
local function is_list_buffer()
    local lang = editor.LexerLanguage
    if lang == "markdown" or lang == "txt2tags" then return true end
    local ext = (props["FileExt"] or ""):lower()
    return ext == "md" or ext == "markdown" or ext == "t2t" or ext == "txt"
end

local function list_continue(ch)
    if ch ~= "\n" and ch ~= "\r" then return end
    if not is_list_buffer() then return end

    local cur_n = editor:LineFromPosition(editor.CurrentPos)
    if cur_n == 0 then return end
    local prev_n = cur_n - 1
    local prev   = (editor:GetLine(prev_n) or ""):gsub("[\r\n]+$", "")
    local indent, content = prev:match("^(%s*)%-%s+(.*)$")
    if not indent then return end

    if content:match("^%s*$") then
        -- item vide : on retire le marqueur de la ligne précédente et on
        -- arrête la liste (pas de marqueur sur la nouvelle ligne).
        local prev_s = editor:PositionFromLine(prev_n)
        editor:SetSel(prev_s, prev_s + #prev)
        editor:ReplaceSel(indent)
        editor:GotoPos(editor:PositionFromLine(cur_n))
        return
    end

    local line_s = editor:PositionFromLine(cur_n)
    -- LineEndPosition est une propriété indexée, pas une méthode (comme
    -- StyleAt plus haut) : editor:LineEndPosition(n) échoue silencieusement
    -- côté SciTE ("attempt to call a SciTE_MT_IFacePropertyBinding value").
    editor:SetSel(line_s, editor.LineEndPosition[cur_n])
    editor:ReplaceSel(indent .. "- ")
end

local _prev_OnChar_t2tfmt = OnChar
function OnChar(ch)
    list_continue(ch)
    if _prev_OnChar_t2tfmt then return _prev_OnChar_t2tfmt(ch) end
end
