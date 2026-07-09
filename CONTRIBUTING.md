# Contributing

Thanks for helping out! This project is intentionally tiny: two bash scripts,
no build step, no dependencies beyond `tmux` and `fzf`.

## Found a bug? Have an idea?

Open an issue - the templates walk you through what to include, so you don't
need to know the codebase. Screenshots of the menu are always welcome.

## Making a change

1. Fork and clone the repo.
2. Edit `keep-ssh-agent-alive` (the menu) or `install.sh` (the setup).
3. Try it in a real terminal: run `./keep-ssh-agent-alive` directly from the repo -
   no need to reinstall while developing. Create a session, open it, leave
   with `F12`, rename it, stop it. Test both languages (`language='vi'` /
   `language='en'` in `~/.config/keep-ssh-agent-alive/config`).
4. Lint it: `shellcheck keep-ssh-agent-alive install.sh` (CI runs this too).
5. Open a pull request. Keep it small; one change per PR.

## Ground rules for the code

- Stay dependency-free: bash + tmux + fzf only.
- Everything must be reachable through the menu. Hotkeys are shortcuts for
  menu rows, never the only way to do something - the whole point is that
  users shouldn't have to memorize commands.
- Keep it friendly to people who barely use a terminal: plain-language
  prompts, confirmation before destructive actions, sensible defaults.
