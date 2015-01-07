function ll
	if isatty 1
		ls -l --color=always $argv | pager
	else
		ls -l $argv
	end
end
