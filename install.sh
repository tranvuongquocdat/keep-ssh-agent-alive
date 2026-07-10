#!/usr/bin/env bash
#
# One-time setup. Asks a few questions, installs the deps it needs,
# and drops the command in ~/.local/bin. Safe to re-run.

set -e

here=$(cd "$(dirname "$0")" && pwd)
bin_dir="$HOME/.local/bin"
cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/keep-ssh-agent-alive"
share_dir="${XDG_DATA_HOME:-$HOME/.local/share}/keep-ssh-agent-alive"

# --- language (asked first; the list comes straight from lang/) ---------------
echo "Language / Ngôn ngữ"
codes=()
i=0
for f in "$here"/lang/*.sh; do
  i=$((i + 1))
  codes+=("$(basename "$f" .sh)")
  echo "  $i) $(sed -n "s/^lang_name='\(.*\)'/\1/p" "$f")"
done
read -r -p "[1]: " c
case $c in *[!0-9]* | '') c=1 ;; esac
{ [ "$c" -ge 1 ] && [ "$c" -le "$i" ]; } || c=1
language=${codes[$((c - 1))]}

if [ "$language" = 'vi' ]; then
  t_need='Cần cài thêm:'
  t_now='Cài ngay? [Y/n]:'
  t_self='Vui lòng tự cài các gói trên rồi chạy lại tập tin này.'
  t_no_pm='Không tìm thấy trình quản lý gói quen thuộc. Vui lòng tự cài rồi chạy lại.'
  t_name='Tên lệnh'
  t_name_rule='Chỉ dùng chữ, số, _ và -.'
  t_conflict='Lưu ý: lệnh này đã tồn tại trên hệ thống, nên chọn tên khác.'
  t_def="Lệnh mặc định cho phiên mới (gõ 'shell' nếu chỉ cần shell)"
  t_done='Đã cài tại:'
  t_path1='Thư mục ~/.local/bin chưa nằm trong PATH. Thêm dòng sau vào ~/.bashrc hoặc ~/.zshrc:'
  t_run='Gõ lệnh sau để bắt đầu:'
else
  t_need='Need to install:'
  t_now='Install now? [Y/n]:'
  t_self='Please install the packages above yourself, then run this again.'
  t_no_pm='No familiar package manager found. Please install manually, then run this again.'
  t_name='Command name'
  t_name_rule='Letters, digits, _ and - only.'
  t_conflict='Note: this command already exists on this system; consider a different name.'
  t_def="Default command for new sessions (type 'shell' for a plain shell)"
  t_done='Installed at:'
  # shellcheck disable=SC2088  # literal text for the user to read
  t_path1="~/.local/bin is not on your PATH yet. Add this line to ~/.bashrc or ~/.zshrc:"
  t_run='Type this to start:'
fi

install_pkg() {
  if command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y "$@"
  elif command -v dnf >/dev/null; then sudo dnf install -y "$@"
  elif command -v brew >/dev/null; then brew install "$@"
  elif command -v pacman >/dev/null; then
    if [ -n "${MSYSTEM:-}" ]; then pacman -S --noconfirm --needed "$@"
    else sudo pacman -S --noconfirm --needed "$@"; fi
  else return 1
  fi
}

# --- deps ---------------------------------------------------------------------
missing=()
for d in tmux fzf; do command -v "$d" >/dev/null || missing+=("$d"); done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "$t_need ${missing[*]}"
  read -r -p "$t_now " a
  case ${a:-Y} in
    [nN]*) echo "$t_self"; exit 1 ;;
  esac
  install_pkg "${missing[@]}" || { echo "$t_no_pm"; exit 1; }
fi

# --- questions ------------------------------------------------------------------
echo
read -r -p "$t_name [run_claude]: " name
name=${name:-run_claude}
case $name in
  *[!a-zA-Z0-9_-]*) echo "$t_name_rule"; exit 1 ;;
esac
command -v "$name" >/dev/null 2>&1 && echo "⚠ $t_conflict"

read -r -p "$t_def [claude]: " def
def=${def:-claude}
[ "$def" = 'shell' ] && def=''

# --- install --------------------------------------------------------------------
mkdir -p "$bin_dir" "$cfg_dir" "$share_dir/lang"
cp "$here/keep-ssh-agent-alive" "$bin_dir/$name"
chmod +x "$bin_dir/$name"
cp "$here"/lang/*.sh "$share_dir/lang/"

esc=$(printf '%s' "$def" | sed "s/'/'\\\\''/g")
printf "language='%s'\ndefault_command='%s'\nsession_prefix='agent'\nmouse='off'\nmax_hours='0'\n" \
  "$language" "$esc" >"$cfg_dir/config"

echo
echo "✓ $t_done $bin_dir/$name"
case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *)
    echo
    echo "$t_path1"
    # shellcheck disable=SC2016
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    ;;
esac
echo
echo "$t_run $name"
