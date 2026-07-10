# Contributing

Thanks for helping out! This project is intentionally tiny: two bash scripts,
no build step, no dependencies beyond `tmux` and `fzf`.

## Found a bug? Have an idea?

Open an issue - the templates walk you through what to include, so you don't
need to know the codebase. Screenshots of the menu are always welcome.

## Making a change

1. Fork and clone the repo.
2. Edit `keep-ssh-agent-alive` (the menu), `install.sh` (the setup), or a
   file in `lang/` (interface text).
3. Try it in a real terminal: run `./keep-ssh-agent-alive` directly from the
   repo - no need to reinstall while developing. Walk through all four menu
   items: open, create, stop (multi-select and "stop all"), settings. Test
   both languages via Settings.
4. Lint it: `shellcheck keep-ssh-agent-alive install.sh lang/*.sh` (CI runs
   this too).
5. Open a pull request. Keep it small; one change per PR.

## Adding a language

Copy `lang/en.sh` to `lang/<code>.sh` (e.g. `fr.sh`), translate the values,
keep the variable names. The language appears in Settings automatically.
That's the whole job - this is a very welcome first contribution.

## Ground rules for the code

- Stay dependency-free: bash + tmux + fzf only.
- Menus only, no hotkeys to memorize. Every action is a visible row you
  reach with arrow keys and Enter; Esc always goes back. The few keys that
  exist (Space to tick, F12 to leave a session) are always written on the
  screen where they apply.
- Keep it friendly to people who barely use a terminal: plain-language
  prompts, confirmation before destructive actions, sensible defaults.
- All user-facing text goes through `lang/` files - never hardcode a string
  in the menu script.
