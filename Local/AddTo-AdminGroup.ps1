$user = Read-Host "Enter Username"
Add-LocalGroupMember -Group "Administrators" -Member $user
