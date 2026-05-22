# Cache eval output so we avoid a subprocess fork on every shell start.
# By default the cache is invalidated when the binary changes. Pass --check <file>
# to invalidate on a different file (e.g. a lock file updated by a package manager).
_cached_eval() {
  local invalidate
  if [[ $1 == --check ]]; then
    invalidate=$2; shift 2
  else
    invalidate=$(command -v $1)
  fi
  local cache="$HOME/.cache/zsh/${1:t}.zsh"
  [[ ! -f $cache || "$invalidate" -nt $cache ]] && { mkdir -p "${cache:h}"; "$@" > $cache }
  source $cache
}


# Automatically set terminal tab title (https://github.com/kovidgoyal/kitty/issues/930#issuecomment-716118208)
_set_tab_title() { print -Pn "\e]0;%~\a" }
precmd_functions+=(_set_tab_title)
