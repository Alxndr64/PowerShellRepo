# Set the path to the folder containing the CSV files
$folderPath = Read-Host "Paste path to folder"

# Set the search string
$searchString = Read-Host "Paste string to search for"

# Get all CSV files in the folder
$csvFiles = Get-ChildItem -Path $folderPath -Filter "*.csv"

# Iterate through each CSV file
foreach ($csvFile in $csvFiles) {
    # Import the data from the CSV file
    $data = Import-Csv -Path $csvFile.FullName

    # Search for the string in the CSV data
    $matches = $data | Where-Object { $_ -match $searchString }

    # Check if any matches were found
    if ($matches) {
        # Display the filename
        Write-Host "Matches found in file: $($csvFile.Name)"

        # Display the matching rows
        $matches | Format-Table
    }
}
