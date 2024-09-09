$systems = Get-content Remote/Users-Active/systems.conf

function Users-Active([string]$name, [string]$ip){
    Write-Host "Checking ACtive Users..."
    $FormatEnumerationLimit = -1
    $users = (query user /server:$ip) -replace '\s{2,}', ',' | ConvertFrom-Csv -Header "USERNAME","SESSIONNAME","ID","STATE","IDLE TIME","LOGON TIME" | Select-Object -Property 'USERNAME', 'STATE'
    foreach($user in $users){
        write-output "$($user.USERNAME) $($user.STATE)"
    }
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
            Users-Active $name $ip
        }
    }
}
Read-Host "..."