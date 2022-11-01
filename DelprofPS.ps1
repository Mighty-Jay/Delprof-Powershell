function Local
{
    # Grab all the user profiles and ignore anything in our exceptions
$Profiles = Get-CimInstance Win32_UserProfile | Where-Object {((!$_.Special) -and ($_.LocalPath -ne "C:\Users\Administrator") -and ($_.LocalPath -ne "C:\Users\Public") -and ($_.LocalPath -ne "C:\Users\Default") -and ($_.LocalPath -ne "C:\Users\defaultuser0"))}
#Grabs the profile Local Paths so we are able to see what names on them
$ProfileName = $Profiles | Select-Object LocalPath
# Get the number of profiles to use in -PercentComplete
$ProfilesCount = $Profiles.Count 

#Show what profiles are going to be deleted
Write-Host "These profiles have been found:"
#Writes it out on each line so it's easier to read
ForEach ($item in $ProfileName){
    Write-Host $item
}
#Asks the user to hit enter to make sure they are happy with profiles being deleted 
Pause

# This for loop iterates through profiles and deletes them as well as creates our progress bar
Function Clear-Profile 
{
    for ($i = 1; $i -lt $ProfilesCount; $i++)
    { 
        # Our progress bar is generated and updated 
        Write-Progress -Activity 'Removing Profiles' -Status "Deleted $i out of $ProfilesCount profiles" -PercentComplete (($i/$ProfilesCount) * 100) 

        # Here we're suppressing errors and continuing while deleting our profiles 
        Remove-CimInstance $Profiles[$i] -EV Err -EA SilentlyContinue 
    }
    # Remove progress bar once complete
    Write-Progress -Activity 'Removing Profiles' -Status 'Complete!' -Completed
}

# Call function
Clear-Profile;

# Remove all leftover profiles that remain ocasionally due to noncritical and inconsistent bug and suppress errors. Not suppressing errors causes as many error windows to show as there were $ProfilesCount.
$Profiles | Remove-CimInstance -EV Err -EA SilentlyContinue 

# Give success message to inform user of script completion
Write-Host "Profiles Deleted!"
Start-Sleep -Seconds 2
Exit-PSHostProcess
}

Local;
