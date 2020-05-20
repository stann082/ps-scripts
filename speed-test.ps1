$nodeLocation = Get-Command node -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
if ($nodeLocation -eq $null) {
    echo "nodejs not found... Please install"
    exit 1
}

$npmLocation = Get-Command node -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
if ($npmLocation -eq $null) {
    echo "npm not found... Please install nodejs"
    exit 1
}

echo "Testing the internet speed..."
$speedResult = fast -u
$timestamp = Get-Date -Format "MM-dd-yyyy HH:mm"

echo "$timestamp|Download: $($speedResult[0])|Upload: $($speedResult[1])"

