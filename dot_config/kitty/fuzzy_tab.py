import json
import os
import subprocess
import sys


def main(args):
    try:
        result = subprocess.run(
            ["kitty", "@", "ls"],
            capture_output=True,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        print(f"kitty @ ls failed: {e.stderr}", file=sys.stderr)
        input("Press enter...")
        return None

    data = json.loads(result.stdout)

    entries = []
    home = os.path.expanduser("~")
    for os_window in data:
        for tab in os_window.get("tabs", []):
            tab_id = tab["id"]
            tab_title = tab.get("title", "")
            active_win = None
            for w in tab.get("windows", []):
                if w.get("is_focused") or w.get("is_active_window"):
                    active_win = w
                    break
            if active_win is None and tab.get("windows"):
                active_win = tab["windows"][0]

            win_title = active_win.get("title", "") if active_win else ""
            cwd = active_win.get("cwd", "") if active_win else ""
            if cwd.startswith(home):
                cwd = "~" + cwd[len(home) :]

            entries.append(f"{tab_id}\t[{tab_title}] {win_title}  ({cwd})")

    if not entries:
        print("No tabs found")
        input("Press enter...")
        return None

    fzf_input = "\n".join(entries)
    try:
        fzf = subprocess.run(
            [
                "/opt/homebrew/bin/mise",
                "x",
                "--",
                "fzf",
                "--with-nth=2..",
                "--delimiter=\t",
                "--prompt=Tab> ",
                "--reverse",
            ],
            input=fzf_input,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as e:
        print(f"fzf not found: {e}")
        input("Press enter...")
        return None

    if fzf.returncode != 0 or not fzf.stdout.strip():
        return None

    return fzf.stdout.split("\t", 1)[0].strip()


def handle_result(args, answer, target_window_id, boss):
    if not answer:
        return
    try:
        tab_id = int(answer)
    except ValueError:
        return
    tab = boss.tab_for_id(tab_id)
    if tab:
        boss.set_active_tab(tab)
