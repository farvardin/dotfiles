-- sexpr_eval.lua
-- Évaluation d'expressions style Lisp (s-expressions), via le menu contextuel.
-- Sélectionner une expression comme "(+ 75 1581 1000)", clic droit, "Évaluer" :
-- la sélection est remplacée par "(+ 75 1581 1000) = 2656".
--
-- Loading (add to your startup script):
--   dofile(props["SciteUserHome"] .. "/.scite/sexpr_eval.lua")
--
-- Tools-menu / context-menu command (add to your .properties file):
--   command.name.27.*=Évaluer
--   command.27.*=EvalSExpr
--   command.mode.27.*=subsystem:lua,savebefore:no
--
--   -- IDM_TOOLS(1100) + N gives the context-menu command id for command.name.N.*
--   -- Toujours inconditionnel : voir CLAUDE.md pour pourquoi un if/match ne marche pas ici.
--   user.context.menu=...|||Évaluer|1127

-- ── Fonctions disponibles ────────────────────────────────────────────────────
-- Table ouverte : ajouter une entrée suffit à exposer une nouvelle fonction
-- aux s-expressions, ex. SEXPR_FUNCS["pow"] = function(a, b) return a ^ b end

SEXPR_FUNCS = {
    ["+"]    = function(...) local s = 0 for _, v in ipairs({...}) do s = s + v end return s end,
    ["*"]    = function(...) local s = 1 for _, v in ipairs({...}) do s = s * v end return s end,
    ["-"]    = function(a, ...)
        local rest = {...}
        if #rest == 0 then return -a end
        local s = a
        for _, v in ipairs(rest) do s = s - v end
        return s
    end,
    ["/"]    = function(a, ...)
        local rest = {...}
        if #rest == 0 then return 1 / a end
        local s = a
        for _, v in ipairs(rest) do s = s / v end
        return s
    end,
    ["mod"]  = function(a, b) return a % b end,
    ["min"]  = function(...) return math.min(...) end,
    ["max"]  = function(...) return math.max(...) end,
    ["abs"]  = function(a) return math.abs(a) end,
    ["sqrt"] = function(a) return math.sqrt(a) end,
    ["expt"] = function(a, b) return a ^ b end,
    ["floor"] = function(a) return math.floor(a) end,
    ["ceil"]  = function(a) return math.ceil(a) end,
}

-- ── Tokenizer ────────────────────────────────────────────────────────────────

local function tokenize(str)
    local tokens = {}
    local i, n = 1, #str
    while i <= n do
        local c = str:sub(i, i)
        if c:match("%s") then
            i = i + 1
        elseif c == "(" or c == ")" then
            tokens[#tokens + 1] = c
            i = i + 1
        else
            local j = i
            while j <= n and not str:sub(j, j):match("[%s()]") do
                j = j + 1
            end
            tokens[#tokens + 1] = str:sub(i, j - 1)
            i = j
        end
    end
    return tokens
end

-- ── Parser ───────────────────────────────────────────────────────────────────
-- Grammaire : expr := nombre | symbole | "(" expr* ")"
-- Une liste "(f x y ...)" est représentée en Lua par {f, x, y, ...}.

local function parse(tokens)
    local pos = 1

    local function parse_expr()
        local tok = tokens[pos]
        if tok == nil then error("expression incomplète") end
        if tok == "(" then
            pos = pos + 1
            local list = {}
            while tokens[pos] ~= ")" do
                if tokens[pos] == nil then error("parenthèse fermante manquante") end
                list[#list + 1] = parse_expr()
            end
            pos = pos + 1 -- consomme ")"
            return list
        elseif tok == ")" then
            error("parenthèse fermante inattendue")
        else
            pos = pos + 1
            return tonumber(tok) or tok -- nombre, sinon symbole (nom de fonction)
        end
    end

    local result = parse_expr()
    if tokens[pos] ~= nil then error("caractères en trop après l'expression") end
    return result
end

-- ── Évaluateur ───────────────────────────────────────────────────────────────

local function eval(node)
    if type(node) == "number" then return node end
    if type(node) ~= "table" then error("élément non évaluable : " .. tostring(node)) end
    if #node == 0 then error("liste vide non évaluable") end

    local fname = node[1]
    if type(fname) ~= "string" then error("fonction attendue en tête de liste") end
    local fn = SEXPR_FUNCS[fname]
    if not fn then error("fonction inconnue : " .. fname) end

    local args = {}
    for i = 2, #node do args[i - 1] = eval(node[i]) end
    return fn(table.unpack(args))
end

local function format_number(n)
    if n == math.floor(n) and math.abs(n) < 1e15 then
        return string.format("%d", n)
    end
    return tostring(n)
end

-- ── Commande ─────────────────────────────────────────────────────────────────

function EvalSExpr()
    local sel_start, sel_end = editor.SelectionStart, editor.SelectionEnd
    if sel_start == sel_end then
        print("Évaluer : sélectionnez d'abord une expression, ex. (+ 1 2 3)")
        return
    end

    local text = editor:textrange(sel_start, sel_end):match("^%s*(.-)%s*$")
    local ok, result = pcall(function() return eval(parse(tokenize(text))) end)
    if not ok then
        print("Erreur d'évaluation : " .. tostring(result))
        return
    end

    editor:BeginUndoAction()
    editor:SetSel(sel_start, sel_end)
    editor:ReplaceSel(text .. " = " .. format_number(result))
    editor:EndUndoAction()
end
