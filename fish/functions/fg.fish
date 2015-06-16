function fg
	# Suppress the annoying help message when there are no jobs
	if test (count (jobs)) -gt 0
		builtin fg $argv
	end 
	true
end
