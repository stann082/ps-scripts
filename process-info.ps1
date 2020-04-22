#region Functions

function showDuration($id, $name) {
    $startTime = (Get-Process -Id $id).StartTime
    if ($startTime -eq $null) {
        echo "$name [$id]; Duration: N/A"
        return
    }

    $timeSpan = New-TimeSpan -Start $startTime
    $duration = ""
    if ($timeSpan.Days -gt 0) {
        $duration += "{0} days " -f $timeSpan.Days 
    }
    if ($timeSpan.Hours -gt 0) {
        $duration += "{0} hours " -f $timeSpan.Hours 
    }
    if ($timeSpan.Minutes -gt 0) {
        $duration += "{0} minutes" -f $timeSpan.Minutes 
    }
    if ($duration -eq "") {
        $duration += "{0} seconds" -f $timeSpan.Seconds
    }
    echo "$name [$id]; Duration: $duration"
}

#endregion

if ($args.Count -eq 0) {
    echo "Must specify a process... (e.g. .\process-info.ps1 notepad)"
    echo "Additional arguments:     -a, --all:      Show all running processes"
    echo "Additional arguments:     -k, --kill:     Kill specified processes`n"
    exit 1
}

if ($args.Count -eq 1 -and ($args[0] -eq "--kill" -or $args[0] -eq "-k")) {
    echo "Must specify a process to kill... (e.g. .\process-info.ps1 notepad --kill)`n"
    exit 1
}

if ($args.Count -eq 1 -and ($args[0] -eq "--all" -or $args[0] -eq "-a")) {
    $processArgs = (Get-Process).ProcessName |sort -unique
} else {
    $processArgs = $args
}

if (($args.Contains("--all") -or $args.Contains("-a")) -and ($args.Contains("--kill") -or $args.Contains("-k"))) {
    echo "Can't kill all processes at once, are you crazy?!"
    exit 1
}

if ($args.Contains("--kill") -or $args.Contains("-k")) {
    foreach ($processArg in $processArgs) {
        $names = (Get-Process $processArg -ErrorAction 'silentlycontinue').ProcessName |sort -unique
        foreach ($name in $names) { 
            echo "Killing $name..."
            Stop-Process -Name $name -Force
        }
    }

    exit 0
}

foreach ($processArg in $processArgs) {
    $ids = (Get-Process "*$processArg*" -ErrorAction 'silentlycontinue').Id
    foreach ($id in $ids) { 
        $processName = (Get-Process -Id $id).ProcessName
        showDuration $id $processName
    }
}

