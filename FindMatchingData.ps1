#Script to find matching data in different spreadsheets

# Specify the file paths of the two Excel spreadsheets
$file1Path = "C:\Users\tvtofa\OneDrive - BlueScope\Documents\Projects\Network\MPLS\SuperNetting.xlsx"
$file2Path = "C:\Users\tvtofa\OneDrive - BlueScope\Documents\Projects\Network\MPLS\MPLS Project.xlsx"

# Load the ImportExcel module
Import-Module ImportExcel

# Load both Excel files into variables
$file1Data = Import-Excel -Path $file1Path
$file2Data = Import-Excel -Path $file2Path

# Specify the column for matching values in both files
$matchingColumn1 = "Display Name"  # Change to your column name or index
$matchingColumn2 = "ColumnA"  # Change to your column name or index

# Specify the column for additional information in both files
$infoColumn1 = "Column2"  # Change to your column name or index
$infoColumn2 = "ColumnB"  # Change to your column name or index

# Initialize an empty array to store the results
$results = @()

# Loop through each row in the first file
foreach ($row1 in $file1Data) {
    $matchingValue = $row1.$matchingColumn1
    $infoValue = $row1.$infoColumn1
    $matchingValueLocation = "File 1, Row $($row1.PSObject.Properties['RowIndex'].Value), $($matchingColumn1)"
    
    # Loop through each row in the second file to find matches
    foreach ($row2 in $file2Data) {
        if ($matchingValue -eq $row2.$matchingColumn2) {
            $infoValue2 = $row2.$infoColumn2
            $matchingValueLocation2 = "File 2, Row $($row2.PSObject.Properties['RowIndex'].Value), $($matchingColumn2)"
            
            # Create an object with the matching values and their locations
            $result = [PSCustomObject]@{
                "MatchingValue" = $matchingValue
                "InfoValue1" = $infoValue
                "MatchingValueLocation1" = $matchingValueLocation
                "InfoValue2" = $infoValue2
                "MatchingValueLocation2" = $matchingValueLocation2
            }
            
            # Add the result to the results array
            $results += $result
        }
    }
}

# Display the results in the console
$results | Format-Table -AutoSize
