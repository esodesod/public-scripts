on open fileList
	-- Get the first file from the list
	set inputFile to POSIX path of (item 1 of fileList)
	-- Set inputfile
	set escapedInputFile to do shell script "printf %s " & quoted form of inputFile
	-- Wrap the file path in double quotes explicitly
	set quotedInputFile to "\"" & escapedInputFile & "\""
	
	-- Path to WezTerm and Neovim
	set weztermPath to "/opt/homebrew/bin/wezterm" -- full path to WezTerm
	set nvimPath to "/opt/homebrew/bin/nvim" -- full path to Neovim
	
	-- Check if WezTerm is running
	try
		set weztermRunning to do shell script "ps aux | grep '[W]ezTerm' | grep -v grep"
	on error
		set weztermRunning to ""
	end try
	
	-- Check if Neovim is running
	try
		set nvimRunning to do shell script "ps aux | grep '[n]vim' | grep -v grep"
	on error
		set nvimRunning to ""
	end try
	
	if weztermRunning is "" then
		-- CASE: WezTerm is NOT running. Need to start WezTerm first.
		do shell script "open -a WezTerm"
		-- Delay to ensure WezTerm starts up
		delay 1.0
		-- Start Neovim with the file in double quotes
		do shell script weztermPath & " cli send-text 'nvim " & quotedInputFile & " ' --no-paste"
		-- Simulate pressing the "Return" key separately
		do shell script weztermPath & " cli send-text $'\\x0d' --no-paste"
		
	else
		if nvimRunning is "" then
			-- CASE: WezTerm is running but Neovim is not running. Open a new (WezTerm) tab and start Neovim with the file
			-- Start Neovim with the file in double quotes
			do shell script weztermPath & " cli send-text 'nvim " & quotedInputFile & " ' --no-paste"
			-- Simulate pressing the "Return" key separately
			do shell script weztermPath & " cli send-text $'\\x0d' --no-paste"
		else
			-- CASE: Both WezTerm AND Neovim are running. Open the file directly within Neovim, in a new (Neovim) tab
			-- TRY: First exit Neovim's "Terminal Mode" (if active). This command does not do anything if already in Normal Mode
			do shell script weztermPath & " cli send-text $'\\x1C\\x0E' --no-paste"
			-- Call new tabe within Neovim and open the file using escapedInputFile
			do shell script weztermPath & " cli send-text ':tabe " & escapedInputFile & " ' --no-paste"
			-- Simulate pressing the "Return" key separately
			do shell script weztermPath & " cli send-text $'\\x0d' --no-paste"
		end if
	end if
end open
