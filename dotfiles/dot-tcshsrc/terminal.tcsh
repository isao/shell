# keys
bindkey "^[[5C" forward-word
bindkey "^[[C"  forward-word
bindkey "^[[5D" backward-word
bindkey "^[[D"  backward-word
bindkey "^I"    complete-word-fwd
bindkey -k down history-search-forward
bindkey -k up   history-search-backward
bindkey "^w"    delete-word
bindkey "^[[3~" delete-char

# flags #

# completions, corrections
# correct options are all | cmd | complete
set implicitcd
set correct = cmd
set complete = enhance
set autolist

# color?
set color
set colorcat

# ~/.history contains line: history -S
# histdup 'prev' no immediate dupes; 'all' no dupes in history
set history = 10000
set savehist = (10000 merge)
set histdup = 'prev'

# ls
set listflags = 'hx'
set listlinks
#unset addsuffix

# watch for local logins
set watch = ( 1 any any )
set who = '%B%n%b %a %l from host %B%M%b at %t'

# don't logout
set autologout = 0

# feedback
set notify
set noding
set ellipsis

# prompt, xterm title
switch ($TERM)
  case "xterm*":

		# %{string%}  includes string as a literal escape sequence
		# %n          user name
		# %m          short hostname
		# %c3         last 3 dirs of cwd w/ ~ substitution
		# %~          cwd w/ ~ substition
		# %T          24-hour time
		# %#          promptchars shell var; '#', '>', or '%', etc.
		# %L          clear to eol or eop
		# !#          history substution of current event
		set prompt = '%{\033]0;%n@%m:%c03\007%}%T%n%# %L'
		# currently running command(s)
		sched +0:00 alias postcmd 'printf "\033]0;%s %s\007" `hostname -s` "\!#"'
    breaksw

  default:
    set prompt = '%T%n@%m:%c2%# '
    breaksw
endsw
