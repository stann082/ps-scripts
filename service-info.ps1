#region Functions

function displayService($name) {
    $service = Get-Service -Name $name
    $serviceName = $service.DisplayName
    $serviceStatus = $service.Status
    echo "$serviceName [$serviceStatus]"
}

#endregion

if ($args.Count -eq 0) {
    echo "Must specify a service... (e.g. .\service-info.ps1 notepad)"
    echo "Additional arguments:     -a, --all:      Show all running services"
    echo "Additional arguments:     -k, --kill:     Kill specified services`n"
    exit 1
}

if ($args.Count -eq 1 -and ($args[0] -eq "--stop")) {
    echo "Must specify a service to stop... (e.g. .\service-info.ps1 sshd --stop)`n"
    exit 1
}

if ($args.Count -eq 1 -and ($args[0] -eq "--all" -or $args[0] -eq "-a")) {
    $serviceArgs = (Get-Service).DisplayName |sort -unique
} else {
    $serviceArgs = $args
}

if (($args.Contains("--all") -or $args.Contains("-a")) -and ($args.Contains("--stop"))) {
    echo "Can't kill all servicees at once, are you crazy?!"
    exit 1
}

if ($args.Contains("--stop")) {
    foreach ($serviceArg in $serviceArgs) {
        $names = (Get-Service $serviceArg -ErrorAction 'SilentlyContinue').Name |sort -unique
        foreach ($name in $names) { 
            echo "Stopping $name..."
            Stop-Service -Name $name -Force
            displayService $name
        }
    }

    exit 0
}

if ($args.Contains("--start")) {
    foreach ($serviceArg in $serviceArgs) {
        $names = (Get-Service $serviceArg -ErrorAction 'SilentlyContinue').Name |sort -unique
        foreach ($name in $names) { 
            echo "Starting $name..."
            Start-Service -Name $name -ErrorAction 'SilentlyContinue'
            displayService $name
        }
    }

    exit 0
}

if ($args.Contains("--restart")) {
    foreach ($serviceArg in $serviceArgs) {
        $names = (Get-Service $serviceArg -ErrorAction 'SilentlyContinue').Name |sort -unique
        foreach ($name in $names) { 
            echo "Restarting $name..."
            Restart-Service -Name $name -ErrorAction 'SilentlyContinue'
            displayService $name
        }
    }

    exit 0
}

foreach ($serviceArg in $serviceArgs) {
    $names = (Get-Service "*$serviceArg*" -ErrorAction 'SilentlyContinue').Name
    foreach ($name in $names) { 
        displayService $name
    }
}

