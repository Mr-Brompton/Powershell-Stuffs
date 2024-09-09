$systems = Get-content systems.conf

function system-checkOnline([string]$name, [string]$ip){
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Host "system: $name" -ForegroundColor Green
        Write-Host "IP: $ip" -ForegroundColor Green
    }
    else {
        Write-Host "system: $name" -ForegroundColor Red
        Write-Host "IP: $ip" -ForegroundColor Red
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
        system-checkOnline $name $ip
    }
}
Read-Host " "