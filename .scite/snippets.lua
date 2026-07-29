-- snippets.lua
-- Text snippet expansion for SciTE
--
-- Usage:
--   Ctrl+Shift+S   : popup list — choose a snippet to insert
--   <trigger> Tab  : type a trigger word then press Tab to expand inline
--
-- Loading (SciTE only supports one ext.lua.startup.script):
--   Option A — this is your only startup script:
--     ext.lua.startup.script=$(SciteDefaultHome)/snippets.lua
--   Option B — you already have a startup script (e.g. SciteStartup.lua),
--              add this line at the end of that file:
--     dofile(props["SciteDefaultHome"] .. "/snippets.lua")
--
-- Keybinding (add to your .properties file):
--   command.name.10.*=Show Snippets
--   command.10.*=ShowSnippets
--   command.mode.10.*=subsystem:lua,savebefore:no
--   command.shortcut.10.*=Ctrl+Shift+S
--
-- ZK_ID format override (add to your .properties file):
--   zk.id.format=id%Y%M%Dx%h%m%s

-- ── Configuration (globals — readable and writable by other scripts) ──────────

-- Format used by $ZK_ID and ExpandDate().  Tokens:
--   %Y  4-digit year    %M  2-digit month   %D  2-digit day
--   %h  2-digit hour    %m  2-digit minute  %s  2-digit second
-- Can be overridden via the SciTE property zk.id.format=<fmt> or directly:
--   ZK_ID_FORMAT = "%Y%M%D"
ZK_ID_FORMAT = "id%Y%M%Dx%h%m%s"

-- Snippet table { trigger = body }.
-- Add entries from any other script:  SNIPPETS["foo"] = "bar $ZK_ID"
-- Body variables: $ZK_ID  $CURSOR  $SELECTION
SNIPPETS = {
    zk   = "$ZK_ID",
    date = "%Y-%M-%D",
    broken_bar = "¦",
    date_H2 = "== %Y-%M-%D ==",
    todo    = "TODO($ZK_ID): $CURSOR", 
    ref = "== Références == \n\n%----------------\n$ZK_ID\n%----------------\n\nVoir également :\n- \n- \n\n\n#tag\n\n\n%EOF\n",
}

-- ── Internal ──────────────────────────────────────────────────────────────────

local SNIPPET_LIST_ID = 102
local _saved_sel = ""

-- Apply the %Y/%M/%D/%h/%m/%s tokens to a format string.
local function apply_date_tokens(fmt)
    local t = os.date("*t")
    return (fmt
        :gsub("%%Y", string.format("%04d", t.year))
        :gsub("%%M", string.format("%02d", t.month))
        :gsub("%%D", string.format("%02d", t.day))
        :gsub("%%h", string.format("%02d", t.hour))
        :gsub("%%m", string.format("%02d", t.min))
        :gsub("%%s", string.format("%02d", t.sec)))
end

-- ── Public API ────────────────────────────────────────────────────────────────

-- Apply the %Y / %M / %D / %h / %m / %s date tokens to any format string.
-- The property zk.id.format is ignored here — pass your own format explicitly.
--   ExpandDate("%Y-%M-%D")  →  "2026-05-26"
function ExpandDate(fmt)
    return apply_date_tokens(fmt)
end

-- Return the current ZK ID according to ZK_ID_FORMAT (or zk.id.format property).
--   GetZkId()  →  "id20260526x143022"
function GetZkId()
    local fmt = props["zk.id.format"]
    if not fmt or fmt == "" then fmt = ZK_ID_FORMAT end
    return apply_date_tokens(fmt)
end

-- Expand $ZK_ID / $CURSOR / $SELECTION variables in a string.
-- sel_text (optional) overrides the current editor selection for $SELECTION.
--   ExpandVars("note $ZK_ID")  →  "note id20260526x143022"
function ExpandVars(body, sel_text)
    sel_text = sel_text or ""
    body = apply_date_tokens(body)
    body = body:gsub("%$ZK_ID",     GetZkId())
    body = body:gsub("%$SELECTION", (sel_text:gsub("%%", "%%%%")))
    return body
end

-- Insert a snippet at the current caret, expanding all variables.
-- $CURSOR marks where the caret lands after insertion.
--   InsertSnippet("TODO($ZK_ID): $CURSOR")
function InsertSnippet(body, sel_text)
    local text = ExpandVars(body, sel_text or "")
    local cur  = text:find("$CURSOR", 1, true)
    if cur then text = text:gsub("%$CURSOR", "", 1) end
    local pos = editor.CurrentPos
    editor:ReplaceSel(text)
    if cur then editor:GotoPos(pos + cur - 1) end
end

-- Add or update a snippet at runtime.
--   AddSnippet("sig", "-- $ZK_ID  Alan")
function AddSnippet(trigger, body)
    SNIPPETS[trigger] = body
end

-- Show a popup list of all defined snippets (bound to Ctrl+Shift+S).
function ShowSnippets()
    local keys = {}
    for k in pairs(SNIPPETS) do keys[#keys + 1] = k end
    table.sort(keys)
    if #keys == 0 then
        print("snippets: no snippets defined")
        return
    end
    _saved_sel = editor:GetSelText()
    local old_sep = editor.AutoCSeparator
    editor.AutoCSeparator = 10
    editor:UserListShow(SNIPPET_LIST_ID, table.concat(keys, "\n"))
    editor.AutoCSeparator = old_sep
end

-- ── SciTE event hooks ─────────────────────────────────────────────────────────

local function tab_expand()
    local pos    = editor.CurrentPos
    local line_n = editor:LineFromPosition(pos)
    local line_s = editor:PositionFromLine(line_n)
    local prefix = (editor:GetLine(line_n) or ""):sub(1, pos - line_s)
    local trig   = prefix:match("([%w_]+)$")
    if trig and SNIPPETS[trig] then
        editor:SetSel(pos - #trig, pos)
        InsertSnippet(SNIPPETS[trig], "")
        return true
    end
    return false
end

local _old_OnKey = OnKey
function OnKey(k, shift, ctrl, alt)
    if k == 9 and not shift and not ctrl and not alt then
        if tab_expand() then return true end
    end
    if _old_OnKey then return _old_OnKey(k, shift, ctrl, alt) end
end

local _old_OnUserListSelection = OnUserListSelection
function OnUserListSelection(tp, sel)
    if tp == SNIPPET_LIST_ID then
        if SNIPPETS[sel] then InsertSnippet(SNIPPETS[sel], _saved_sel) end
        return true
    end
    if _old_OnUserListSelection then return _old_OnUserListSelection(tp, sel) end
end

local _n = 0; for _ in pairs(SNIPPETS) do _n = _n + 1 end
--print("snippets.lua loaded — " .. _n .. " snippets")
