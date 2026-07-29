-- recent_files.lua
-- Historique des fichiers récemment ouverts dans SciTE
--
-- Chargement (dans votre script de démarrage) :
--   dofile(props["SciteDefaultHome"] .. "/recent_files.lua")
--
-- Keybinding dans votre fichier .properties :
--   command.name.15.*=Fichiers récents
--   command.15.*=ShowRecentFiles
--   command.mode.15.*=subsystem:lua,savebefore:no
--   command.shortcut.15.*=Ctrl+Shift+R
--
-- Dépendances : wish + list_picker.tcl (même dossier que ce script).
--
-- Configuration (.properties) :
--   file.recent.max=50               nombre max de fichiers mémorisés (défaut 50)
--   file.recent.list=/chemin/exact   chemin du fichier de persistance
--                                    (défaut ~/.scite/recent_files.txt)

local RF_MAX_DEFAULT = 50

-- Dossier de ce script (pour trouver list_picker.tcl à côté)
local _script_dir = (debug.getinfo(1, "S").source:match("^@(.+)/[^/]+$") or "")

-- Cache en mémoire (chargé une fois depuis le disque, mis à jour à chaque OnOpen)
local _list = nil

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function prop(name, default)
    local v = props[name]
    return (v and v ~= "") and v or default
end

local function list_path()
    local p = prop("file.recent.list", "")
    if p ~= "" then return p end
    return (os.getenv("HOME") or "") .. "/.scite/recent_files.txt"
end

local function max_entries()
    return tonumber(prop("file.recent.max", "")) or RF_MAX_DEFAULT
end

-- ── Persistance ───────────────────────────────────────────────────────────────

local function load_list()
    if _list then return _list end
    _list = {}
    local f = io.open(list_path(), "r")
    if not f then return _list end
    for line in f:lines() do
        line = line:match("^(.-)%s*$")
        if line ~= "" then _list[#_list + 1] = line end
    end
    f:close()
    return _list
end

local function save_list()
    if not _list then return end
    local f = io.open(list_path(), "w")
    if not f then return end
    local max = max_entries()
    for i = 1, math.min(#_list, max) do
        f:write(_list[i] .. "\n")
    end
    f:close()
end

local function push(path)
    load_list()
    -- Retire les doublons
    for i = #_list, 1, -1 do
        if _list[i] == path then table.remove(_list, i) end
    end
    -- Insère en tête
    table.insert(_list, 1, path)
    -- Tronque
    local max = max_entries()
    while #_list > max do table.remove(_list) end
    save_list()
end

-- ── Localisation de list_picker.tcl ──────────────────────────────────────────

local function find_picker()
    local home = os.getenv("HOME") or ""
    local candidates = {
        _script_dir                       .. "/list_picker.tcl",
        home .. "/.scite/list_picker.tcl",
        home .. "/.SciTE/list_picker.tcl",
        (props["SciteDefaultHome"] or "") .. "/list_picker.tcl",
        (props["SciteUserHome"]    or "") .. "/list_picker.tcl",
    }
    for _, p in ipairs(candidates) do
        if p ~= "" and p ~= "/list_picker.tcl" then
            local f = io.open(p, "r")
            if f then f:close(); return p end
        end
    end
    print("recent_files: list_picker.tcl introuvable. Cherché dans :")
    for _, p in ipairs(candidates) do
        if p ~= "" then print("  " .. p) end
    end
    return nil
end

-- ── API publique ──────────────────────────────────────────────────────────────

function ShowRecentFiles()
    local picker = find_picker()
    if not picker then return end

    local list = load_list()

    -- Filtre les fichiers qui n'existent plus
    local existing = {}
    for _, path in ipairs(list) do
        local f = io.open(path, "r")
        if f then f:close(); existing[#existing + 1] = path end
    end

    if #existing == 0 then
        print("recent_files: aucun fichier récent")
        return
    end

    -- Fichier temporaire : label\tchemin
    local tmp = os.tmpname()
    local f   = io.open(tmp, "w")
    if not f then return end
    for _, path in ipairs(existing) do
        local base = path:match("([^/]+)$") or path
        local dir  = path:match("^(.+)/[^/]+$") or ""
        -- Abrège le répertoire home en ~
        local home = os.getenv("HOME") or ""
        if home ~= "" then dir = dir:gsub("^" .. home:gsub("[%(%)%.%+%-%*%?%[%^%$%%]", "%%%1"), "~") end
        f:write(base .. "   " .. dir .. "\t" .. path .. "\n")
    end
    f:close()

    local cmd = "wish " .. string.format("%q", picker) ..
                " " .. string.format("%q", "Fichiers récents") ..
                " " .. string.format("%q", "Filtrer…") ..
                " < " .. tmp .. " 2>/dev/null"

    local h    = io.popen(cmd)
    local path = h and h:read("*l")
    if h then h:close() end
    os.remove(tmp)

    if path and path ~= "" then
        scite.Open(path)
    end
end

-- ── Hook OnOpen ───────────────────────────────────────────────────────────────

local _prev_OnOpen = OnOpen
function OnOpen(filename)
    if filename and filename ~= "" then
        push(filename)
    end
    if _prev_OnOpen then return _prev_OnOpen(filename) end
end
