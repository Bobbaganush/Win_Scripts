# Load the first names, last names, and passwords from text files
$firstNames = Get-Content -Path "firstname.txt"
$lastNames = Get-Content -Path "lastname.txt"
$passwords = Get-Content -Path "password.txt"

# Specify the OU path where users will be created
$OUPath = "OU=vulnerable,DC=lab,DC=local"

# Number of users to create
$numberOfUsers = 10  # Change this number to create more or fewer users

# Loop to create users
for ($i = 1; $i -le $numberOfUsers; $i++) {
    # Randomly select a first name and last name
    $firstName = $firstNames | Get-Random
    $lastName = $lastNames | Get-Random
    
    # Create the full name
    $fullName = "$firstName $lastName"
    
    # Set the GivenName
    $givenName = $firstName
    
    # Create the SamAccountName
    $samAccountName = ($firstName.Substring(0,2) + $lastName).ToLower()
    
    # Create the UserPrincipalName
    $userPrincipalName = "$samAccountName@lab.local"
    
    # Randomly select a password
    $accountPassword = $passwords | Get-Random | ConvertTo-SecureString -AsPlainText -Force
    
    # Create the new user in Active Directory
    New-ADUser -Name $fullName `
               -GivenName $givenName `
               -SamAccountName $samAccountName `
               -UserPrincipalName $userPrincipalName `
               -Path $OUPath `
               -AccountPassword $accountPassword `
               -Enabled $true `
               -ChangePasswordAtLogon $false `
               -PasswordNeverExpires $true
               
    Write-Host "Created user: $fullName with SamAccountName: $samAccountName and UPN: $userPrincipalName"
}
