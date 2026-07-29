#!/usr/bin/env python3
# file_browser.py — navigateur de fichiers pour SciTE
#
# Usage : python3 file_browser.py [dossier_de_départ]
# Sortie stdout : chemin absolu du fichier sélectionné (vide si annulé)

import os
import sys
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk


class FileBrowser(Gtk.Window):
    def __init__(self, start_dir):
        super().__init__(title="Ouvrir fichier")
        self.set_default_size(580, 480)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_border_width(6)

        self._current = os.path.abspath(start_dir)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        self.add(vbox)

        # ── Chemin courant (éditable) ─────────────────────────────────────
        self._path_entry = Gtk.Entry()
        self._path_entry.connect("activate", lambda e: self._navigate(
            os.path.expanduser(e.get_text())))
        vbox.pack_start(self._path_entry, False, False, 0)

        # ── Filtre ────────────────────────────────────────────────────────
        self._filter = Gtk.SearchEntry()
        self._filter.set_placeholder_text("Filtrer… (Backspace = dossier parent)")
        self._filter.connect("changed",        self._on_filter_changed)
        self._filter.connect("activate",       lambda e: self._activate_selected())
        self._filter.connect("key-press-event", self._on_filter_key)
        vbox.pack_start(self._filter, False, False, 0)

        # ── Liste (is_dir, label affiché, chemin absolu) ──────────────────
        self._store = Gtk.ListStore(bool, str, str)
        self._view  = Gtk.TreeView(model=self._store)
        self._view.set_headers_visible(False)
        self._view.connect("row-activated",    self._on_row_activated)
        self._view.connect("key-press-event",  self._on_list_key)

        renderer = Gtk.CellRendererText()
        col = Gtk.TreeViewColumn("", renderer, text=1)
        self._view.append_column(col)

        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroll.add(self._view)
        vbox.pack_start(scroll, True, True, 0)

        # ── Statut ────────────────────────────────────────────────────────
        self._status = Gtk.Label(xalign=0)
        vbox.pack_start(self._status, False, False, 0)

        self.connect("destroy",        Gtk.main_quit)
        self.connect("key-press-event", self._on_window_key)

        self._navigate(self._current)
        self._filter.grab_focus()

    # ── Navigation ────────────────────────────────────────────────────────

    def _navigate(self, path):
        path = os.path.abspath(os.path.expanduser(path))
        if not os.path.isdir(path):
            return
        self._current = path
        self._path_entry.set_text(path)
        self._filter.set_text("")
        self._refresh()
        self._filter.grab_focus()

    def _refresh(self):
        q    = self._filter.get_text().lower()
        dirs  = []
        files = []

        try:
            for e in os.scandir(self._current):
                # fichiers cachés : affichés seulement si le filtre commence par "."
                if e.name.startswith(".") and not q.startswith("."):
                    continue
                if q and q not in e.name.lower():
                    continue
                if e.is_dir(follow_symlinks=False):
                    dirs.append(("▶  " + e.name, e.path))
                else:
                    files.append((e.name, e.path))
        except PermissionError:
            pass

        dirs.sort( key=lambda x: x[0].lower())
        files.sort(key=lambda x: x[0].lower())

        self._store.clear()

        parent = os.path.dirname(self._current)
        if parent != self._current:            # pas à la racine du filesystem
            self._store.append([True, "←  ..", parent])

        for label, path in dirs:
            self._store.append([True,  label, path])
        for label, path in files:
            self._store.append([False, label, path])

        n = self._store.iter_n_children(None)
        self._status.set_text(
            f"{len(dirs)} dossier(s)   {len(files)} fichier(s)" +
            (f"   (filtre : {q!r})" if q else "")
        )
        if n > 0:
            self._view.get_selection().select_path(Gtk.TreePath.new_first())

    # ── Sélection ─────────────────────────────────────────────────────────

    def _get_selected(self):
        model, it = self._view.get_selection().get_selected()
        if not it:
            return None, None
        return model[it][2], model[it][0]   # chemin, is_dir

    def _activate_selected(self):
        path, is_dir = self._get_selected()
        if path is None:
            return
        if is_dir:
            self._navigate(path)
        else:
            sys.stdout.write(path + "\n")
            sys.stdout.flush()
            Gtk.main_quit()

    # ── Événements ────────────────────────────────────────────────────────

    def _on_filter_changed(self, entry):
        self._refresh()

    def _on_filter_key(self, widget, event):
        kv = event.keyval
        if kv == Gdk.KEY_Down:
            self._view.grab_focus()
            return True
        if kv == Gdk.KEY_BackSpace and self._filter.get_text() == "":
            parent = os.path.dirname(self._current)
            if parent != self._current:
                self._navigate(parent)
            return True
        return False

    def _on_list_key(self, widget, event):
        kv = event.keyval
        if kv in (Gdk.KEY_Return, Gdk.KEY_KP_Enter):
            self._activate_selected()
            return True
        if kv == Gdk.KEY_Up:
            model, it = self._view.get_selection().get_selected()
            if it and not model.iter_previous(it):
                self._filter.grab_focus()
                return True
        return False

    def _on_row_activated(self, view, treepath, col):
        it = self._store.get_iter(treepath)
        self._activate_selected()

    def _on_window_key(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()
            return True
        return False


def main():
    if len(sys.argv) > 1:
        start = sys.argv[1]
    else:
        start = os.path.expanduser("~")

    if not os.path.isdir(start):
        start = os.path.dirname(start) or os.path.expanduser("~")

    win = FileBrowser(start)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
