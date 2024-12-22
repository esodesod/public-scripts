on open fileList
	-- Get the first file from the list
	set inputFile to POSIX path of (item 1 of fileList)
	
	-- Escape the file path manually to handle spaces
	set escapedInputFile to do shell script "printf %q " & quoted form of inputFile
	
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
		-- WezTerm is not running, start WezTerm
		do shell script "open -a WezTerm"
		delay 1.0 -- Delay to ensure WezTerm starts up
		
		-- Start Neovim with the file
		do shell script weztermPath & " cli send-text 'nvim " & escapedInputFile & " ' --no-paste"
		-- Simulate pressing the "Return" key separately
		do shell script weztermPath & " cli send-text $'\\x0d' --no-paste"
		
	else
		if nvimRunning is "" then
			-- WezTerm is running but nvim is not running, open a new tab and start nvim with the file
			do shell script weztermPath & " cli send-text 'nvim " & escapedInputFile & " ' --no-paste"
			-- Simulate pressing the "Return" key separately
			do shell script weztermPath & " cli send-text $'\\x0d' --no-paste"
		else
			-- WezTerm and nvim are running, open the file in a new tab in the existing nvim session
			-- First exit nvim's "Terminal Mode" (if active). Does not do anything if already in Normal Mode
			do shell script weztermPath & " cli send-text $'\\x1C\\x0E' --no-paste"
			--			do shell script weztermPath & sendCommand("<C-\\><C-n>")
			do shell script weztermPath & " cli send-text ':tabe " & escapedInputFile & " ' --no-paste"
			-- Simulate pressing the "Return" key separately
			do shell script weztermPath & " cli send-text $'\\x0d' --no-paste"
		end if
	end if
end open
