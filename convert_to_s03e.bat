@echo off
setlocal

set "MODE=apply"
if /I "%~1"=="--dry-run" (
    set "MODE=dryrun"
    shift
)

powershell -NoProfile -ExecutionPolicy Bypass ^
  "$dryRun = '%MODE%' -eq 'dryrun';" ^
  "Get-ChildItem -File | ForEach-Object {" ^
  "    $base = $_.BaseName;" ^
  "    $match = [regex]::Match($base, '^(?<pre>.*?)(1(?<ep>\d{2}))(?<post>.*)$');" ^
  "    if($match.Success) {" ^
  "        $newName = $match.Groups['pre'].Value + 's03e' + $match.Groups['ep'].Value + $match.Groups['post'].Value + $_.Extension;" ^
  "        if($dryRun) {" ^
  "            Write-Host (\"[dry-run] ren \"\"{0}\"\" \"\"{1}\"\"\" -f $_.Name, $newName);" ^
  "        } elseif ($_.Name -ne $newName) {" ^
  "            Write-Host (\"ren \"\"{0}\"\" \"\"{1}\"\"\" -f $_.Name, $newName);" ^
  "            Rename-Item -LiteralPath $_.FullName -NewName $newName;" ^
  "        }" ^
  "    }" ^
  "}" 

endlocal
