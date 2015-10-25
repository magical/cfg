set -x LANG en_US.UTF-8
set -x EDITOR vim
set -x PAGER most
set -x GOPATH $HOME/go

set -x XDG_CONFIG_HOME $HOME/cfg
set -x XDG_CACHE_HOME $HOME/var/cache
set -x XDG_DATA_HOME $HOME/var

# Fish doesn't seem to set this on its own
set -x SHELL /bin/fish

set -x FISHRC ''

set -x VIMINIT 'let $MYVIMRC="$HOME/cfg/vim/vimrc" | source $MYVIMRC'

set -x DVDCSS_CACHE $XDG_CACHE_HOME/dvdcss
set -x LESSHISTFILE $XDG_DATA_HOME/less/history
set -x GNUPGHOME $XDG_CONFIG_HOME/gnupg
set -x PSQLRC $XDG_CONFIG_HOME/psql/psqlrc
set -x XCOMPOSEFILE $XDG_CONFIG_HOME/X11/xcompose
set -x XINITRC $XDG_CONFIG_HOME/X11/xinitrc

set -e CMD_DURATION

if status -l
	set -x PATH $HOME/bin /usr/bin /bin /usr/sbin /sbin $GOPATH/bin /usr/lib/plan9/bin
end

if status -i
	alias rm 'rm -I --dir --one-file-system --preserve-root'
	alias mv 'mv -i'
	alias cp 'cp -i'
	alias ln 'ln -i'

	alias df 'df --si'
	alias du 'du --si'

	alias l ls
	alias e vim
	alias j jobs

	function ls; command ls -AbFv --si --color=auto $argv; end
	function ll; command ls -l -AFv --si  --color=always $argv | most; end
	alias lt 'll -t'

	functions -c cd fish_cd
	function cd
		fish_cd $argv
		and ls
	end

	function __print_exit_status --on-event fish_prompt
		set -l oldstatus $status
		if test "$oldstatus" -ne 0
			echo exit status: $oldstatus
		end
	end

	function __print_command_duration --on-event fish_prompt
		if set -q CMD_DURATION
			echo $CMD_DURATION
		end
	end

	eval (keychain --quiet --eval --agents ssh --dir $HOME/var/./keychain id_rsa | sed 's/[^;]*; and //' | tr \n \;)
end
