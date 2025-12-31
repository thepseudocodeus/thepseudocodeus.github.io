import subprocess
import pandas as pd
import matplotlib.pyplot as plt
import io
from typing import Any

def see(msg: Any) -> None:
    msg = f"{msg}"
    print(msg)


def do_cmd(cmd) -> Any:
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=".")
    see(result)


def new_cmd(cmd: str | None = None):
    if cmd is None:
        return []
    return list(cmd.split())

def git_status():
    cmd = new_cmd("git status")
    do_cmd(cmd)
    # [ ] TODO: use rich or logger for more detailed output
    # see(result)

def add_files_to_git(files = None):
    if files is None:
        files = "."
    print(f"Adding {files} to remote git repo")
    cmd = new_cmd(f"git add {files}") # Split the message into a list for subprocess
    do_cmd(cmd)
    git_status()


def add_commit_message(msg = None):
    if msg is None:
        msg = "default commit message"
    cmd = new_cmd(f"git commit -am '{msg}'")
    do_cmd(cmd)
    git_status()

def push_to_remote(branch: str | None = None):
    if branch is None:
        branch = "main"
    cmd = new_cmd(f"git push origin {branch}")
    do_cmd(cmd)
    git_status()

def get_git_stats_by_author():
    # Run the git shortlog command to get commit counts and author names
    cmd = "git shortlog -sn --all"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=".")

    if result.returncode != 0:
        print(f"Error running git command: {result.stderr}")
        return

    # Parse the output
    data = []
    for line in result.stdout.strip().split("\\n"):
        if line:
            parts = line.strip().split("\\t")
            if len(parts) == 2:
                commits = int(parts[0])
                author = parts[1]
                data.append({"Author": author, "Commits": commits})

    df = pd.DataFrame(data)

    # Print a top contributors summary
    print("Top Contributors:\\n")
    print(df.sort_values(by="Commits", ascending=False).head(10).to_string(index=False))

    # Optional: Visualize the data
    df.set_index("Author").sort_values(by="Commits").plot(
        kind="barh", legend=False, figsize=(10, 6)
    )
    plt.title("Commits per Author")
    plt.xlabel("Number of Commits")
    plt.ylabel("Author")
    plt.grid(axis="x")
    plt.tight_layout()
    plt.show()


def update_git():
    msg = input("ENTER commit message:")
    branch = input("ENTER branch:")
    add_files_to_git()
    add_commit_message(msg)
    push_to_remote(branch)


if __name__ == "__main__":
    # get_git_stats_by_author()
    update_git()
