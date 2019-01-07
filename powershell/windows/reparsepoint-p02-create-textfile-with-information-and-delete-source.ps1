#<#
# ####################################################################################################################
# SECTION: REPARSEPOINT FILES CLEANUP
# * Generate a textfile with relevant information and remove the ReparsePoint
# * Applies to files not matched with vault/backup
# * Applies to files that needs manual intervention anyway
# TBD: UPDATE header information
# TBD: ADD EXPORT-CSV. With relevant information - so may be re-used if needed in the future
# TBD: ADD DISCLAIMER - RUN THIS LAST - ONLY REPARSEPOINT FILES SHOULD BE LEFT AT THIS POINT
# TBD: OPTIONAL - ADD LEFT-ONLY VERIFICATION BEFORE THIS ACTION?
foreach ($file in $files_dst) {
    # Verify that the file is still a ReparsePoint, then populate & log
    if ($file.Attributes -match "ReparsePoint") {
        # Debug
        Write-Host $file.fullname "is detected to be ReparsePoint"
        # Debug
        Write-Host $file.fullname "generating text file with information"
        # Outfile: Set new fullname
        $outfile = ($file.fullname)+("-readme-restore.txt")
        # Outfile: Set header
        $header = "This file was archived to vault (due to previous archiving policies), and was not able to automatically restore in migration process. We created this placeholder file, just in case. If the file is needed, please contact helpdesk, and we'll try to locate the file in older backups, if possible. Please bear in mind that this is a really time consuming process (hours/days), and if other (faster) re-creation means is possible, please try them first."
        # Outfile: Append header to outfile
        $header | Out-File -LiteralPath $outfile -Append
        Write-Output "TECHNICAL INFORMATION - About the ReparsePoint file" | Out-File -LiteralPath $outfile -Append
        # Outfile: Append information to outfile
        $file | Format-List * | Out-File -LiteralPath $outfile -Append
        # Check if outfile exists, and if so, remove the ReparsePoint
        $outfile_check = (Test-Path -LiteralPath $outfile)
        if ($outfile_check -eq $True) {
            # Debug
            Write-Host $outfile "successfully located, you may remove the ReparsePoint now" -ForegroundColor Green
            # Remove the ReparsePoint
            Write-Host $outfile "removing the ReparsePoint file" -ForegroundColor Green
            Remove-Item -LiteralPath $file.FullName
        }
        if ($outfile_check -eq $False) {
            # Debug
            Write-Host $outfile "Not found. Do nothing. I'm serious." -ForegroundColor Red
        }
    }
}
#>