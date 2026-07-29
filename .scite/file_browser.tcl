#!/usr/bin/env wish
# file_browser.tcl — navigateur de fichiers pour SciTE
#
# Usage  : wish file_browser.tcl [dossier_de_départ]
# Sortie : chemin absolu du fichier sélectionné sur stdout (vide si annulé)
#
# Navigation :
#   Filtre      — mise à jour en temps réel (sous-chaîne, insensible à la casse)
#   ↓ (filtre)  — descend dans la liste
#   ↑ (1er item)— remonte au filtre
#   Backspace (filtre vide) — dossier parent
#   Entrée / double-clic    — ouvre fichier ou entre dans dossier
#   Chemin + Entrée         — navigue vers un chemin absolu (~  supporté)
#   Échap       — annule

package require Tk

# ── État ──────────────────────────────────────────────────────────────────────

set ::cur  ""   ;# dossier courant
set ::filt ""   ;# texte du filtre

# ── Procédures ────────────────────────────────────────────────────────────────

proc navigate {dir} {
    # Expand ~ et normalise
    set dir [file normalize [regsub {^~} $dir $::env(HOME)]]
    if {![file isdirectory $dir]} return
    set ::cur $dir
    .m.path delete 0 end
    .m.path insert 0 $dir
    set ::filt ""
    refresh
    focus .m.filter
}

proc refresh {args} {
    set q        [string tolower $::filt]
    set show_dot [expr {[string index $q 0] eq "."}]

    # Lister le dossier courant
    set raw {}
    catch { set raw [glob -nocomplain -tails -directory $::cur -- *] }
    if {$show_dot} {
        set hidden {}
        catch { set hidden [glob -nocomplain -tails -directory $::cur -- .*] }
        foreach n $hidden {
            if {$n ne "." && $n ne ".."} { lappend raw $n }
        }
    }

    set dirs  {}
    set files {}
    foreach name $raw {
        if {!$show_dot && [string match .* $name]} continue
        if {$q ne "" && [string first $q [string tolower $name]] < 0} continue
        set fp [file join $::cur $name]
        if {[file isdirectory $fp]} {
            lappend dirs  $name
        } else {
            lappend files $name
        }
    }
    set dirs  [lsort -nocase $dirs]
    set files [lsort -nocase $files]

    # Reconstruire la liste
    set t .m.list.tree
    $t delete [$t children {}]

    set parent [file dirname $::cur]
    if {$parent ne $::cur} {
        $t insert {} end -text "←  .." -values [list $parent]
    }
    foreach name $dirs {
        $t insert {} end \
            -text "▶  $name" \
            -values [list [file join $::cur $name]]
    }
    foreach name $files {
        $t insert {} end \
            -text $name \
            -values [list [file join $::cur $name]]
    }

    set first [lindex [$t children {}] 0]
    if {$first ne ""} { $t selection set $first ; $t focus $first ; $t see $first }

    set msg "[llength $dirs] dossier(s)   [llength $files] fichier(s)"
    if {$q ne ""} { append msg "   (filtre : \"$q\")" }
    .m.status configure -text $msg
}

proc activate {} {
    set t   .m.list.tree
    set sel [$t selection]
    if {$sel eq ""} return
    set path [lindex [$t item $sel -values] 0]
    if {[file isdirectory $path]} {
        navigate $path
    } else {
        puts $path
        flush stdout
        destroy .
    }
}

proc to_parent {} {
    set p [file dirname $::cur]
    if {$p ne $::cur} { navigate $p }
}

# ── Widgets ───────────────────────────────────────────────────────────────────

wm title    . "Ouvrir fichier"
wm geometry . 580x480
wm minsize  . 300 200
wm protocol . WM_DELETE_WINDOW { destroy . }

ttk::frame .m -padding 4
pack .m -fill both -expand 1

# Chemin courant (éditable — Entrée pour naviguer)
ttk::entry .m.path
pack .m.path -fill x -pady {0 3}
bind .m.path <Return> { navigate [.m.path get] }

# Filtre (mise à jour en temps réel via trace)
ttk::entry .m.filter -textvariable ::filt
pack .m.filter -fill x -pady {0 3}
trace add variable ::filt write refresh

bind .m.filter <Down>      { focus .m.list.tree ; break }
bind .m.filter <Return>    { activate ; break }
bind .m.filter <BackSpace> {
    if {[.m.filter get] eq ""} { to_parent ; break }
}

# Liste + scrollbar
ttk::frame .m.list
pack .m.list -fill both -expand 1 -pady {0 3}

ttk::treeview .m.list.tree \
    -show tree \
    -selectmode browse \
    -yscrollcommand { .m.list.vsb set }
.m.list.tree column #0 -stretch yes

ttk::scrollbar .m.list.vsb \
    -orient vertical \
    -command { .m.list.tree yview }

pack .m.list.vsb  -side right -fill y
pack .m.list.tree -side left  -fill both -expand 1

bind .m.list.tree <Return>   { activate }
bind .m.list.tree <Double-1> { activate }
bind .m.list.tree <Up> {
    set t   .m.list.tree
    set top [lindex [$t children {}] 0]
    if {[$t focus] ne "" && [$t focus] eq $top} { focus .m.filter ; break }
}

# Statut
ttk::label .m.status -anchor w
pack .m.status -fill x

bind . <Escape> { destroy . }

# ── Démarrage ─────────────────────────────────────────────────────────────────

set start [lindex $argv 0]
if {$start eq ""} {
    set start $::env(HOME)
} elseif {[file isfile $start]} {
    set start [file dirname $start]
} elseif {![file isdirectory $start]} {
    set start $::env(HOME)
}

navigate $start
