# Check if Software Restriction Policies key exists
$srpKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
if (-not (Test-Path $srpKeyPath)) {
    # Create Software Restriction Policies key
    New-Item -Path $srpKeyPath -Force
}

# Set the Enforcement policy to apply restrictions to all users except local administrators
Set-ItemProperty -Path $srpKeyPath -Name "AuthenticodeEnabled" -Value 0
Set-ItemProperty -Path $srpKeyPath -Name "PolicyScope" -Value 1

# Update group policies
Invoke-Expression -Command "gpupdate /force"
