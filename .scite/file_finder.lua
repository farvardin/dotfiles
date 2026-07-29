-- file_finder.lua
-- Sélecteur de fichiers pour SciTE (navigateur avec filtre)
--
-- Chargement (dans votre script de démarrage) :
--   dofile(props["SciteDefaultHome"] .. "/file_finder.lua")
--
-- Keybinding dans votre fichier .properties :
--   command.name.13.*=Find File
--   command.13.*=FindFile
--   command.mode.13.*=subsystem:lua,savebefore:no
--   command.shortcut.13.*=Ctrl+Shift+O
--
-- Backends (premier trouvé utilisé) :
--   file_browser.tcl  →  wish      (Tcl/Tk, recommandé)
--   file_browser.py   →  python3   (Python+GTK, fallback)
--
-- Configuration (.properties) :
--   file.finder.start=~/src              dossier de départ
--   file.finder.browser=/chemin/exact    chemin explicite vers le script browser

-- Dossier de ce script (pour trouver file_browser.* à côté)
local _script_dir = (debug.getinfo(1, "S").source:match("^@(.+)/[^/]+$") or "")

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function prop(name, default)
    local v = props[name]
    return (v and v ~= "") and v or default
end

local function start_dir()
    local p = prop("file.finder.start", "")
    if p ~= "" then
        return p:gsub("^~", os.getenv("HOME") or "~")
    end
    local filedir = props["FileDir"]
    if filedir and filedir ~= "" then return filedir end
    return os.getenv("HOME") or "."
end

-- ── Localisation du script browser ───────────────────────────────────────────

-- Retourne (interpréteur, chemin_script) ou (nil, nil).
-- Cherche d'abord file_browser.tcl (wish), puis file_browser.py (python3).
local function find_browser()
    -- Chemin explicite dans .properties
    local explicit = prop("file.finder.browser", "")
    if explicit ~= "" then
        local f = io.open(explicit, "r")
        if f then
            f:close()
            local interp = explicit:match("%.tcl$") and "wish" or "python3"
            return interp, explicit
        end
    end

    local home  = os.getenv("HOME") or ""
    local bases = {
        _script_dir,
        home .. "/.scite",
        home .. "/.SciTE",
        props["SciteDefaultHome"] or "",
        props["SciteUserHome"]    or "",
    }

    -- Ordre de préférence : tcl > py
    local backends = { {"tcl", "wish"}, {"py", "python3"} }

    for _, base in ipairs(bases) do
        if base ~= "" then
            for _, b in ipairs(backends) do
                local p = base .. "/file_browser." .. b[1]
                local f = io.open(p, "r")
                if f then f:close(); return b[2], p end
            end
        end
    end

    print("file_finder: file_browser.tcl / .py introuvable. Cherché dans :")
    for _, base in ipairs(bases) do
        if base ~= "" then print("  " .. base) end
    end
    print("file_finder: définissez file.finder.browser=/chemin/vers/file_browser.tcl")
    return nil, nil
end

-- ── API publique ──────────────────────────────────────────────────────────────

function FindFile()
    local interp, script = find_browser()
    if not script then return end

    local cmd = interp .. " " .. string.format("%q", script) ..
                " "           .. string.format("%q", start_dir()) ..
                " 2>/dev/null"

    local h    = io.popen(cmd)
    local path = h and h:read("*l")
    if h then h:close() end

    if path and path ~= "" then
        scite.Open(path)
    end
end
