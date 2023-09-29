# Define the paths to the source and destination spreadsheets
$sourceFile = "C:\Users\tvtofa\OneDrive - BlueScope\Documents\My Scripts\BBNA Networking\Docs-Outputs\JunipersFile.csv"
$destinationFile = "C:\Users\tvtofa\OneDrive - BlueScope\Documents\My Scripts\BBNA Networking\Docs-Outputs\BBNA-Inventory3.csv"

# Load the Excel com objects
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

# Open the destination spreadsheet
$destinationWorkbook = $excel.Workbooks.Open($destinationFile)
$destinationWorksheet = $destinationWorkbook.Sheets.Item(1)

# Read the source file content
$fileContent = Get-Content $sourceFile -Raw

# Split the file content into sections based on the delimiter "---"
$sections = $fileContent -split "---"

# Loop through each section
foreach ($section in $sections) {
    # Skip empty sections
    if ([string]::IsNullOrWhiteSpace($section)) {
        continue
    }
    
    # Find the hostname in the section
    $hostnameRegex = "Hostname:\s+(.+)"
    $hostname = [regex]::Match($section, $hostnameRegex).Groups[1].Value.Trim()
    
    # Check if the hostname is empty
    if ([string]::IsNullOrWhiteSpace($hostname)) {
        continue
    }
    
    # Find the model in the section
    $modelRegex = "Model:\s+(.+)"
    $model = [regex]::Match($section, $modelRegex).Groups[1].Value.Trim()
    
    # Find the MAC addresses in the section
    $macAddresses = [regex]::Matches($section, "Base address\s+(.+)")
    $macAddresses = $macAddresses.ForEach({ $_.Groups[1].Value.Trim() })

    # Find the matching row in the destination spreadsheet based on the hostname
    $destinationRow = $destinationWorksheet.Range("A:A").Find($hostname)
    
    if ($destinationRow) {
        # Write the model to column C of the matching row in the destination spreadsheet
        $destinationWorksheet.Cells.Item($destinationRow.Row, 3).Value2 = $model

        # Write the MAC addresses separated by "-" to column E of the matching row in the destination spreadsheet
        $destinationWorksheet.Cells.Item($destinationRow.Row, 5).Value2 = $macAddresses -join "-"
    } else {
        # If a matching row is not found, display the hostname and a message
        Write-Host "No matching row found for hostname: $hostname"
    }
}

# Save and close the destination spreadsheet
$destinationWorkbook.Save()
$destinationWorkbook.Close()

# Quit Excel
$excel.Quit()
