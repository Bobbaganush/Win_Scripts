# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Define the list of users
$userList = @("user1@azuread.com", "user2@azuread.com", "user3@azuread.com") # Add more users as needed

# Loop through each user in the list
foreach ($userPrincipalName in $userList) {
    # Get the user's object ID
    $user = Get-AzureADUser -ObjectId $userPrincipalName

    if ($user) {
        # Get the user's group memberships
        $userGroups = Get-AzureADUserMembership -ObjectId $user.ObjectId | Where-Object { $_.ObjectType -eq "Group" }

        # Create a list to store group details
        $groupList = @()

        # Loop through each group and add details to the list
        foreach ($group in $userGroups) {
            $groupDetails = [PSCustomObject]@{
                GroupName = $group.DisplayName
                GroupId = $group.ObjectId
            }
            $groupList += $groupDetails
        }

        # Define the output CSV file path for this user
        $csvFilePath = "C:\Users\user\Downloads\$($userPrincipalName.Split('@')[0]).csv" # Replace with your desired file path

        # Export the group details to a CSV file
        $groupList | Export-Csv -Path $csvFilePath -NoTypeInformation

        Write-Output "The user's group memberships have been exported to $csvFilePath"
    } else {
        Write-Output "User $userPrincipalName not found."
    }
}

Write-Output "All users processed. CSV files have been saved to the specified directory."
