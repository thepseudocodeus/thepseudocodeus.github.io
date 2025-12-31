import subprocess
import pandas as pd
import matplotlib.pyplot as plt
import io



def get_git_stats_by_author():
    # Run the git shortlog command to get commit counts and author names
    cmd = "git shortlog -sn --all"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=".")

    if result.returncode != 0:
        print(f"Error running git command: {result.stderr}")
        return

    # Parse the output
    data = []
    for line in result.stdout.strip().split('\\n'):
        if line:
            parts = line.strip().split('\\t')
            if len(parts) == 2:
                commits = int(parts[0])
                author = parts[1]
                data.append({"Author": author, "Commits": commits})

    df = pd.DataFrame(data)

    # Print a top contributors summary
    print("Top Contributors:\\n")
    print(df.sort_values(by="Commits", ascending=False).head(10).to_string(index=False))

    # Optional: Visualize the data
    df.set_index("Author").sort_values(by="Commits").plot(kind='barh', legend=False, figsize=(10, 6))
    plt.title("Commits per Author")
    plt.xlabel("Number of Commits")
    plt.ylabel("Author")
    plt.grid(axis='x')
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    get_git_stats_by_author()
