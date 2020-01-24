# Remove all powershell aliases
Get-Alias | Remove-Alias -Force

# TODO: rework to use only one argument
Function which([string]$command) {
    (Get-Command -CommandType Application $command -TotalCount 1).Path
}

# ls aliases
Function ls() {
    $path=(which ls)
    Invoke-Expression "$path --color=auto $args"
}
Function l() { ls "$args" }
Function la() { ls -a "$args" }
Function ll() { ls -lh "$args" }
Function lla() { ls -lha "$args" }

# cd aliases
# TODO: fix args
Function cd() { Set-Location "$args" }
Function cd..() { cd .. }
Function cd-() { cd - }
Function cd~() { cd ~ }
Function ..() { cd .. }
