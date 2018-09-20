# Copy files from $srcpath to $dstpath
# Simple folder (not recurse)
# * Remove destination files, only if exists in source
# * Replace attributes on files, e.g. creationtime
# Based on some inputs from https://stackoverflow.com/questions/21593625/how-to-use-powershell-to-copy-file-and-retain-original-timestamp
$srcpath = 'C:\temp\src'
$dstpath = 'C:\temp\dst'
$files = Get-ChildItem $srcpath

foreach ($srcfile in $files) {
  # Build destination file path
  $dstfile = [io.FileInfo]($dstpath, '\', $srcfile.name -join '')

  # Remove destination files first (only if exists in $srcpath)
  # Reason: Vaulted files has attributes "ReparsePoints" or "Offline". Force will not work on Copy-Item, hence Remove-Item first.
  if ($dstfile.Exists) { Remove-Item $dstfile }

  # Copy the file
  Copy-Item $srcfile.FullName $dstfile.FullName

  # Make sure file was copied and exists before copying over properties/attributes
  if ($dstfile.Exists) {
    $dstfile.CreationTime = $srcfile.CreationTime
    $dstfile.LastAccessTime = $srcfile.LastAccessTime
    $dstfile.LastWriteTime = $srcfile.LastWriteTime
    $dstfile.Attributes = $srcfile.Attributes
  }
}