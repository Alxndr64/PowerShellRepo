# Set the root folder path
$rootFolder = Read-Host "Paste path to folder"

# Set the search string
$searchString = Read-Host "Paste string to search for"

# Get all files of different types within the root folder and its subfolders
$files = Get-ChildItem -Path $rootFolder -File -Recurse

# Initialize an array to store results
$results = @()

# Iterate through each file and check if it contains the search string
foreach ($file in $files) {
    $fileContent = Get-Content -Path $file.FullName -Raw

    if ($fileContent -match $searchString) {
        $result = [PSCustomObject]@{
            FilePath = $file.FullName
            MatchedLine = ($fileContent -split "`r`n" | Select-String -Pattern $searchString).Line
        }
        
        $results += $result
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\Users\tvtofa\OneDrive - BlueScope\Desktop\Results.csv" -NoTypeInformation
Write-Host "Search results exported to Results.csv"

# Read and display the CSV file
$csvResults = Import-Csv -Path "C:\Users\tvtofa\OneDrive - BlueScope\Desktop\Results.csv"

Write-Host "Search Results:"
$csvResults | Format-Table -AutoSize
