$systems = Get-content Remote/Drives-Encrypted/systems.conf

function Drives-Encrypted([string]$name, [string]$ip){
    Write-Host "Checking Encrypted Drives..."
    $bde = manage-bde -cn $ip -status
    $ComputerName = $bde | Select-String "Computer Name:" 
    $ComputerName = ($ComputerName -split ": ")[1]

    $ProtectionStatus = $bde | Select-String "Protection Status:"
    $ProtectionStatus = ($ProtectionStatus -split ": ")[1]
    $ProtectionStatus = $ProtectionStatus -replace '\s','' #removes the white space in this field

#Add all fields to an array that contains custom formatted objects with desired fields
$bdeObject += New-Object psobject -Property @{'Computer Name'=$ComputerName; 'Conversion Status'=$ProtectionStatus;}
$bdeObject | Export-Csv EncryptionList.csv -NoTypeInformation
}

function System-CheckOnline([string]$name, [string]$ip){
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Host "system: $name" -ForegroundColor Green
        Write-Host "IP: $ip" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "system: $name" -ForegroundColor Red
        Write-Host "IP: $ip" -ForegroundColor Red
        return $false
    }
}

foreach ($system in $Systems) {
    <# $system is the current item #>
    if ($system.Substring(0,1) -eq "#") {
        <# Write output if first character is # #>
        write-output $system
    }
    else {
        <# Where line is not a comment, Prepare text for ICMP ping #>
        $name = $system.split(',')[0]
        $ip = $system.split(',')[1]
        $ip = $ip.replace(" ", "")
        if (System-CheckOnline $name $ip){
            Drives-Encrypted $name $ip
        }
    }
}
Read-Host "..."