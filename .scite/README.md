# SciTE Lua scripts

Lua extensions for SciTE.

## Installation

SciTE only supports **one** `ext.lua.startup.script`. Load all scripts from a single startup file (e.g. `SciteStartup.lua`):

```lua
dofile(props["SciteDefaultHome"] .. "/file_finder.lua")
dofile(props["SciteDefaultHome"] .. "/t2t_navigator.lua")
dofile(props["SciteDefaultHome"] .. "/snippets.lua")
```

Or with a user-local path:

```lua
dofile(props["SciteUserHome"] .. "/.scite/file_finder.lua")
dofile(props["SciteUserHome"] .. "/.scite/t2t_navigator.lua")
dofile(props["SciteUserHome"] .. "/.scite/snippets.lua")
```

---

## file_finder.lua — Fuzzy file picker

Replace Ctrl+O with a filterable list of files — type a few characters of the filename to jump to it.

### Keybindings

Ctrl+O is intercepted automatically. To also bind a command explicitly:

```properties
command.name.13.*=Find File
command.13.*=FindFile
command.mode.13.*=subsystem:lua,savebefore:no
command.shortcut.13.*=Ctrl+Shift+O

command.name.14.*=Rescan Files
command.14.*=FindFileRescan
command.mode.14.*=subsystem:lua,savebefore:no
```

### Usage

| Shortcut | Action |
|----------|--------|
| **Ctrl+O** | Open file picker — type to filter by filename, Enter to open |
| **Ctrl+Shift+O** | Same (explicit command binding) |

The list shows `filename  →  /full/path` sorted alphabetically by filename. Typing filters by prefix — e.g. typing `sni` jumps to `snippets.lua`.

### Configuration

Add to your `.properties` file:

```properties
# Directories to scan — colon-separated, ~ is expanded (default: current file's directory)
file.finder.roots=~/src:~/notes

# Directory/file names to skip — comma-separated
file.finder.exclude=.git,node_modules,__pycache__,.cache,build,dist

# Maximum recursion depth (default: 6)
file.finder.depth=6

# File extensions to include — comma-separated, empty = all files
file.finder.extensions=lua,py,md,txt

# Maximum number of files shown (default: 2000)
file.finder.max=2000

# Set to 0 to keep the native Ctrl+O dialog and use only the explicit command
file.finder.override.ctrlO=1
```

### Notes

- Files are indexed on first open and cached until the directory changes.
- Call `FindFileRescan()` from any script or command to force a rescan.
- Requires `find` (standard on Linux/macOS). Not supported on Windows without a `find` port.

---

## t2t_navigator.lua — Heading navigator

Navigate document headings (txt2tags and Markdown) via a popup list or a clickable TOC in the output pane.

### Keybindings

Add to your `.properties` file:

```properties
command.name.11.*=Goto Heading
command.11.*=GotoT2TAnyHeading
command.mode.11.*=subsystem:lua,savebefore:no
command.shortcut.11.*=Ctrl+Shift+H

command.name.12.*=Table of Contents
command.12.*=T2TTableOfContents
command.mode.12.*=subsystem:lua,savebefore:no
command.shortcut.12.*=Ctrl+Shift+M
```

### Usage

| Shortcut | Action |
|----------|--------|
| **Ctrl+Shift+H** | Popup list of all headings — select one to jump to it |
| **Ctrl+Shift+M** | Print a clickable TOC in the output pane |

Clicking a TOC entry scrolls the heading to the top of the view. Jumping to a heading line from the TOC also scrolls it to the top automatically.

### Configuration

Edit the top of `t2t_navigator.lua`:

```lua
-- Symbol for symmetric headings: = Title =  or == Title ==
-- Set to nil to disable.
local HEADING_SYMBOL = "="

-- Also detect Markdown headings: # Title, ## Title …
local MARKDOWN_HEADINGS = false
```

### Heading formats supported

| Style | Example |
|-------|---------|
| txt2tags symmetric | `= Title =`, `== Title ==`, … |
| Markdown (optional) | `# Title`, `## Title`, … |

---

## t2t_format.lua — Context-menu formatting

Right-click formatting for txt2tags **and** Markdown, auto-detected per buffer. Also auto-continues `- ` lists on Enter.

### Keybindings / context menu

Add to your `.properties` file (commands 20-26 reserved for this script):

```properties
command.name.20.*.t2t;*.txt;*.md=Titre 1
command.20.*.t2t;*.txt;*.md=T2THeading1
command.mode.20.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

command.name.21.*.t2t;*.txt;*.md=Titre 2
command.21.*.t2t;*.txt;*.md=T2THeading2
command.mode.21.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

command.name.22.*.t2t;*.txt;*.md=Titre 3
command.22.*.t2t;*.txt;*.md=T2THeading3
command.mode.22.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

command.name.23.*.t2t;*.txt;*.md=Gras
command.23.*.t2t;*.txt;*.md=T2TBold
command.mode.23.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

command.name.24.*.t2t;*.txt;*.md=Italique
command.24.*.t2t;*.txt;*.md=T2TItalic
command.mode.24.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

command.name.25.*.t2t;*.txt;*.md=Souligné
command.25.*.t2t;*.txt;*.md=T2TUnderline
command.mode.25.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

command.name.26.*.t2t;*.txt;*.md=Barré
command.26.*.t2t;*.txt;*.md=T2TStrike
command.mode.26.*.t2t;*.txt;*.md=subsystem:lua,savebefore:no

# IDM_TOOLS(1100) + N gives the context-menu command id for command.name.N.*
# Must stay unconditional — see CLAUDE.md for why an if/match around this fails.
user.context.menu=Titre 1|1120|Titre 2|1121|Titre 3|1122|||Gras|1123|Italique|1124|Souligné|1125|Barré|1126
```

### Usage

Syntax is auto-detected per buffer (lexer, falling back to file extension):

| Action | txt2tags | Markdown |
|--------|----------|----------|
| Titre 1/2/3 | `= x =` / `== x ==` / `=== x ===` | `# x` / `## x` / `### x` |
| Gras | `**x**` | `**x**` |
| Italique | `//x//` | `*x*` |
| Souligné | `__x__` | `<u>x</u>` |
| Barré | `--x--` | `~~x~~` |

Bold/italic/underline/strike toggle off if the selection is already wrapped; with no selection, the marks are inserted with the caret placed between them. Headings replace the whole current line.

### Auto-continued lists

Pressing Enter at the end of a `- ` list item (any indentation level, txt2tags or Markdown) starts the next line with the same marker. Pressing Enter again on an empty item (`- ` with nothing typed) removes the marker instead of adding another one — two Enters in a row ends the list.

```
- first item
- second item⏎        ← Enter here
- ⏎                    ← empty item, Enter again removes the marker and stops
next paragraph
```

---

## sexpr_eval.lua — Context-menu expression evaluator

Evaluate Lisp-style s-expressions from the right-click menu: select `(+ 75 1581 1000)`, right-click, "Évaluer" — the selection is replaced with `(+ 75 1581 1000) = 2656`.

### Keybindings / context menu

Add to your `.properties` file (command 27, no file-extension restriction — it's useful on any file type):

```properties
command.name.27.*=Évaluer
command.27.*=EvalSExpr
command.mode.27.*=subsystem:lua,savebefore:no

# IDM_TOOLS(1100) + N gives the context-menu command id for command.name.N.*
user.context.menu=...|||Évaluer|1127
```

### Usage

Function application is written `(f x y z ...)`, and expressions can nest: `(+ 1 (* 2 3))` → `7`.

| Function | Arity | Example |
|----------|-------|---------|
| `+` `*` | any | `(+ 1 2 3)` → `6` |
| `-` `/` | 1 or more | `(- 10)` → `-10`, `(- 10 3 2)` → `5` |
| `mod` `expt` | 2 | `(mod 7 3)` → `1`, `(expt 2 10)` → `1024` |
| `min` `max` | any | `(max 3 1 2)` → `3` |
| `abs` `sqrt` `floor` `ceil` | 1 | `(sqrt 16)` → `4` |

Results that are whole numbers are printed without a decimal point. Errors (unbalanced parentheses, unknown function, empty list) print to the output pane instead of touching the selection.

### Extending

Add a function by adding one entry to the `SEXPR_FUNCS` table at the top of `sexpr_eval.lua`:

```lua
SEXPR_FUNCS["pow"] = function(a, b) return a ^ b end
```

---

## snippets.lua — Snippet expansion

Insert reusable text snippets with dynamic variables including a configurable Zettelkasten ID (`$ZK_ID`).

### Keybinding

```properties
command.name.10.*=Show Snippets
command.10.*=ShowSnippets
command.mode.10.*=subsystem:lua,savebefore:no
command.shortcut.10.*=Ctrl+Shift+S
```

Adjust the command number if it conflicts with an existing command.

### Usage

Two ways to insert a snippet:

| Method | Steps |
|--------|-------|
| **Popup list** | Press Ctrl+Shift+S, select a snippet |
| **Inline Tab** | Type a trigger word (e.g. `zk`) then press Tab |

Note: trigger words must be alphanumeric + underscore only (`[%w_]`). Keys with hyphens (e.g. `date-H2`) are only accessible via the popup list.

### Snippet variables

| Variable | Expands to |
|----------|------------|
| `$ZK_ID` | Unique timestamp ID (see format below) |
| `$CURSOR` | Caret is placed here after insertion. Without it, the caret lands at the end of the snippet. |
| `$SELECTION` | Text selected when the snippet was invoked |

Date tokens can also be used directly in snippet bodies:

| Token | Value |
|-------|-------|
| `%Y`  | 4-digit year |
| `%M`  | 2-digit month |
| `%D`  | 2-digit day |
| `%h`  | 2-digit hour |
| `%m`  | 2-digit minute |
| `%s`  | 2-digit second |

### $ZK_ID format

The default format is `id%Y%M%Dx%h%m%s`, producing IDs like `id20260526x143022`.

Override in your `.properties` file:

```properties
zk.id.format=id%Y%M%Dx%h%m%s
```

### Defining snippets

Edit the `SNIPPETS` table at the top of `snippets.lua`:

```lua
SNIPPETS = {
    zk      = "$ZK_ID",
    date    = "%Y-%M-%D",
    date_H2 = "== %Y-%M-%D ==",
    todo    = "TODO($ZK_ID): $CURSOR",
    link    = "[[$ZK_ID $CURSOR]]",
}
```

Add snippets at runtime from any script:

```lua
AddSnippet("sig", "-- $ZK_ID  Alan")
```

### Public API

All symbols are globals, accessible from any script loaded after `snippets.lua`.

**Variables**

| Symbol | Type | Description |
|--------|------|-------------|
| `ZK_ID_FORMAT` | string | Default format for `$ZK_ID` — read/write |
| `SNIPPETS` | table | Snippet table — add entries directly: `SNIPPETS["foo"] = "bar"` |

**Functions**

| Function | Description |
|----------|-------------|
| `GetZkId()` | Return the current `$ZK_ID` string |
| `ExpandDate(fmt)` | Apply `%Y` `%M` `%D` `%h` `%m` `%s` tokens to a format string |
| `ExpandVars(body [, sel])` | Expand `$ZK_ID`, `%Y`…, `$CURSOR`, `$SELECTION` in a string |
| `InsertSnippet(body [, sel])` | Insert a snippet at the caret with full variable expansion |
| `AddSnippet(trigger, body)` | Add or update a snippet at runtime |
| `ShowSnippets()` | Open the popup snippet picker |

**Examples**

```lua
-- format a date string
local s = ExpandDate("%Y-%M-%D")          -- "2026-05-26"

-- override the ZK_ID format
ZK_ID_FORMAT = "%Y%M%D"

-- insert a snippet from another script
InsertSnippet("= $ZK_ID =\n\n$CURSOR")

-- expand variables without inserting
local ref = ExpandVars("ref: $ZK_ID")
```
