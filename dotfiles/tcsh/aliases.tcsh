#
# built-in syntax enhancements
#
alias . pwd
alias .. 'cd ..'
alias cd.. 'cd ..'
alias ls 'ls-F'
alias ll '/bin/ls -lF \!*'
alias lsd '/bin/ls -l \!* | grep ^d'  # ls dirs only
alias ls. '/bin/ls -dF .?*'  # ls dot files & dirs only


#
# one-liners
#
alias = "python -c 'print \!*'"
alias dict "curl -s 'dict://dict.org/d:\!*' | egrep -v '^[0-9]{3} .*|^\.'"
alias e $EDITOR
alias ip "ifconfig | grep 'inet '"
alias man2txt 'man \!* | col -b'
alias rmmacmeta "find \!* \( -name '.DS_Store' -or -name '._*' \) -exec rm -v \{\} \;"
alias rot13 'perl -wne "tr/a-zA-Z/n-za-mN-ZA-M/;print;"'
alias word 'grep \!* /usr/share/dict/words'

# path
alias showenv 'env | sort'
alias showpath 'echo $PATH | tr : "\n"'
alias checkpath 'ls -ld `echo $PATH | tr : "\n"`'

# bf irc
alias irclog 'ssh isao@devservices "tail \!* irclogs/localhost/?usx-fe.log"'
alias ircterm 'ssh -t isao@devservices "screen -dr irc"'

# http://episteme.arstechnica.com/eve/forums/a/tpc/f/8300945231/m/284004131041
# view man page as a PDF
if(-x /Applications/Preview.app) alias man2pdf 'man -t \!* | open -f -a /Applications/Preview.app'
if(-X osascript) alias findercwd 'cd `osascript ~/Repos/shell/osx/findercwd.applescript`'

#
# other
#
if(-X svn) then
  alias ss 'svn status --quiet --ignore-externals \!*'
  alias ss? 'svn status \!* | grep ^\?'
  alias ss?? "svn status --no-ignore \!* |egrep '^[?IX]'"
endif

if(-X git) then
  alias gs 'git status --short --untracked-files=no \!*'
  alias gs? 'git status --short --untracked-files=normal \!*'
  alias gu 'git gui \!*'
  if(-X bbdiff) alias gd 'git difftool \!*'
endif

if(-X cdargs && -r /opt/brew/Cellar/cdargs/1.35/contrib/cdargs-tcsh.csh) then
  source /opt/brew/Cellar/cdargs/1.35/contrib/cdargs-tcsh.csh
endif
