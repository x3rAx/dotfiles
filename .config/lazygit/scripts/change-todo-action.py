#!/usr/bin/env python3

import os
import sys

file = sys.argv[1]

_action = os.environ["X_LAZYGIT_CHANGE_TODO_ACTION"]
_commits_csv = os.environ["X_LAZYGIT_CHANGE_TODO_COMMITS"]
_commits = _commits_csv.split(",")

# rad all lines into a list, prepend each line with a number, then write the lines back to the same file
with open(file, "r") as f:
    lines = f.readlines()

    for i, line in enumerate(lines):
        if line.strip() == "":
            continue
        if line.strip().startswith("#"):
            continue

        [action, commit, *rest] = line.split(" ")

        for commit_to_change in _commits:
            if commit_to_change.startswith(commit):
                action = _action

        print(f"\n==> Setting {commit} to {action}")

        lines[i] = " ".join([action, commit, *rest])

    with open(file, "w") as f:
        f.writelines(lines)
