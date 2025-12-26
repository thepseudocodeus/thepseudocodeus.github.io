refine this into a best in class prompt to provide to an LLM: refine my devcontainer.json I use for vscode to make it easy for me to build a personal knowledge base of my learnings where I start with solving 2 LeetCode problems a day of easy difficulty and once I can consistently solve them in < 10 minutes each, I move to 3 problems with 1 being medium, and then when I can solve them in < 10 minutes overall or 30 minutes for all 3, I move to 5 questions a day, etc until I can do 27-50 (dynamically adjusted by expected time to solve eproblems based on comlexity, novelty, past performance, etc. Note: I would like to do it similar to how the SAT does where based on performance to date it unlocks certain questiosn and difficulties while keep randomness to ensure the experience is not too overwhelming overall. But the difference is I want the system to start more uncertainty at the beginning than the SAT such that it should not be impossible to reach the mosst difficult questions if the first few questions are missed but rather Bayesian updating should adjust the algorithm based on not just actuals but also the difference between what the system predictively expected and the actual as well as the time consumed on theproblem etc to increasingly more accurately guage how I'm performing on that day and having the test maximize my improvement on that specific sday, etc. Dyanmic behavior should be everywhere in this algorithm including the odds of thenext quetion being highly complex after athe current ishighly complex so there are enough quick questiosn testing 1st principle concepts as well as actual leetcode and variety of question types form multiple hoice, to debuggging, to traditional LeetCode, to hacking, mensa puzzles, Jane Street puzzles, code breaking, etc just the solution to everything is possible using python or python and haskell or python haskell and rust, etc with the idea that I think in python, prove in hasekll, implement in rust, orchestrate with Elixir, and rush with Julia) LeetCode-like problems a day in 1.5 hours with a 95% or greater score in terms of completion + solving actual problem requested + passing test cases + meeting constraints  + other LeetCode expectations as well as my additional requirements of: following my Jim Simons & Robert Mercer & RenTec inspired approach to problem solving by building systems to automate exploration of the problem-solution-behavior (PSB) + use of How To Solve It best practices incoporated + use of How To Prove It best practices incoporated + simplicity of answer + simplicity of process + simplicity of code + % of problem solved automatically by existing infrastructure + degree of certainty of predicted results of test made by infrastructure vs my actual performance domain through rapid iterative experimentations that increasingly more quickly help me increase the precision of my definition of the PSB space (with 90% of problems being automatically newly generated variations of existing ones) with 7% being Computer Science Olympiad difficulty or higher, 5% being Mathematics Olympiad difficulty or higher, 3% at MIT PhD Theorectical computer science difficulty or higher, 5% at MIT PhD applied computer science difficulty or higher, 3% at MIT PhD pure mathematics difficulty or higher, 3% at MIT PhD applied mathematics difficulty or higher, 3% at Mensa level question difficulty or higher, 2% at Jane Street question level difficulty or higher, 10% at top 10% of FAANG-equivalent lead senior software engineer difficulty or higher, 10% at top 10% of top AI, ML, NLP, and similar R&D + startup + disruptive innovation creation places in the world level difficulty or higher, 8% at top 5% of top code breaking + cryptography + hacking + cybersecurity firms in the world level difficulty of questions or higher, 15% at the difficulty of questions that Jim Simons, Robert Mercer, and RenTec would ask me to be highered as a leader at the firm, and 7% requiring research to be done at the quality that Jim Simons & Robert Mercer & RenTec would require of me solving a problem and implementing it into the RenTec infrastructure from soup to nuts of the entire process from idea to risk manaement in production with feedback loops. // .devcontainer/devcontainer.json
{
  "name": "RenTec-DevContainer",
  "image": "mcr.microsoft.com/devcontainers/python:3.12-bookworm",
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached",
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ],
  "containerEnv": {
    "SSH_AUTH_SOCK": "/run/host-services/ssh-auth.sock",
    "PYTHONPATH": "${containerWorkspaceFolder}/src"
  },
  "features": {
    "ghcr.io/mamba-org/devcontainer-features/micromamba:1": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": false,
      "installOhMyZsh": false,
      "installTmux": true
    },
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/git-lfs:1": {},
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "forwardPorts": [
    3000, 5000, 5173, 6006, 7000, 8000, 8080, 8501, 8888, 1234, 5432
  ],
  "postCreateCommand": "sudo apt-get update && sudo apt-get install -y libgl1-mesa-glx && pipx install uv",
  "remoteUser": "vscode",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-vscode.vscode-ssh",
        "ms-toolsai.jupyter",
        "esbenp.prettier-vscode",
        "ms-azuretools.vscode-docker",
        "ms-vscode-remote.remote-containers",
        "usernamehw.errorlens",
        "ryanluker.vscode-coverage-gutters",
        "eamodio.gitlens",
        "charliermarsh.ruff",
        "ms-python.black-formatter"
      ],
      "settings": {
        "python.defaultInterpreterPath": "/usr/local/bin/python",
        "python.formatting.provider": "none",
        "python.formatting.blackArgs": ["--line-length=88"],
        "python.languageServer": "Pylance",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": "explicit",
          "source.fixAll.ruff": "explicit",
          "source.fixAll": "explicit"
        },
        "python.linting.lintOnSave": true,
        "python.linting.ruffEnabled": true,
        "python.analysis.typeCheckingMode": "basic",
        "python.analysis.diagnosticMode": "workspace",
        "terminal.integrated.defaultProfile.linux": "bash",
        "terminal.integrated.profiles.linux": {
          "bash": {
            "path": "/bin/bash"
          }
        },
        "devcontainers.copyGitConfig": true,
        "devcontainers.containerUser": "vscode"
      }
    }
  }
}
