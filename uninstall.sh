#!/usr/bin/env bash
#
# Removes the installed command(s), settings, and language files.
# Shows what it found and asks once before touching anything.
# The cloned folder itself stays.

set -e

bin_dir="$HOME/.local/bin"
cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/keep-ssh-agent-alive"
share_dir="${XDG_DATA_HOME:-$HOME/.local/share}/keep-ssh-agent-alive"
socket='keep-ssh-agent-alive'

language='en'
# shellcheck source=/dev/null
[ -f "$cfg_dir/config" ] && . "$cfg_dir/config"

if [ "$language" = 'vi' ]; then
  t_title='Gỡ cài đặt keep-ssh-agent-alive'
  t_nothing='Không tìm thấy bản cài đặt nào. Không có gì để gỡ.'
  t_will='Những thứ sau sẽ bị xoá:'
  t_cmd='lệnh'
  t_cfg='thiết lập'
  t_lang='tập tin ngôn ngữ'
  t_sessions='phiên đang chạy — chúng sẽ bị dừng'
  t_confirm='Tiếp tục? [y/N]:'
  t_cancel='Đã huỷ. Không xoá gì cả.'
  t_done='Đã gỡ xong. Muốn cài lại: chạy ./install.sh'
else
  t_title='Uninstall keep-ssh-agent-alive'
  t_nothing='No installation found. Nothing to remove.'
  t_will='The following will be removed:'
  t_cmd='command'
  t_cfg='settings'
  t_lang='language files'
  t_sessions='running session(s) — they will be stopped'
  t_confirm='Continue? [y/N]:'
  t_cancel='Cancelled. Nothing was removed.'
  t_done='Uninstalled. To reinstall: run ./install.sh'
fi

# Installed commands are copies of the menu script; find them by their marker.
cmds=()
if [ -d "$bin_dir" ]; then
  for f in "$bin_dir"/*; do
    [ -f "$f" ] && grep -q 'keep-ssh-agent-alive' "$f" 2>/dev/null && cmds+=("$f")
  done
fi

n_sessions=0
if command -v tmux >/dev/null 2>&1; then
  n_sessions=$(tmux -L "$socket" list-sessions 2>/dev/null | grep -c . || true)
fi

if [ "${#cmds[@]}" -eq 0 ] && [ ! -e "$cfg_dir" ] && [ ! -e "$share_dir" ] && [ "$n_sessions" -eq 0 ]; then
  echo "$t_nothing"
  exit 0
fi

echo "$t_title"
echo
echo "$t_will"
for f in "${cmds[@]}"; do echo "  - $t_cmd: $f"; done
[ -e "$cfg_dir" ] && echo "  - $t_cfg: $cfg_dir"
[ -e "$share_dir" ] && echo "  - $t_lang: $share_dir"
[ "$n_sessions" -gt 0 ] && echo "  - $n_sessions $t_sessions"
echo
read -r -p "$t_confirm " a
case $a in
  [yY]*) ;;
  *) echo "$t_cancel"; exit 0 ;;
esac

if command -v tmux >/dev/null 2>&1; then
  tmux -L "$socket" kill-server 2>/dev/null || true
fi
for f in "${cmds[@]}"; do rm -f "$f"; done
rm -rf "$cfg_dir" "$share_dir"

echo "✓ $t_done"
