

$counter = 0
$usbdrive = Get-WmiObject win32_diskdrive | Where-Object {$_.interfacetype -like 'USB'}
$drivenum = $usbdrive | Measure-Object
$drivecount = $drivenum.Count

Write-Host " _____ _____ _____                 
|  |  |   __| __  |___ ___ ___ ___ 
|  |  |__   | __ -| . |  _| -_| . |
|_____|_____|_____|  _|_| |___|  _|
                  |_|         |_|  " -ForegroundColor Magenta

if ($drivecount -lt 1)
{
    Write-Host "No USB drive detected! Please connect the drive(s) you wish to prepare for BitLocker encryption and retry." -ForegroundColor Red
}
    else 
    {
        Write-Host "There is currently $drivecount drive(s) connected ready for preperation"
        Start-Sleep -Seconds 1
            foreach($usbdrive in $usbdrive)
            {
                $diskID = $usbdrive.DeviceID.Substring(17,1).trim()
                $disksize = (($usbdrive.Size)/1GB).ToString(".00")+"GB"
                $diskmodel = $usbdrive.Model 
                $diskprep = (diskpart.exe /s disk.txt)
                Write-Host "CAUTION! Are you sure you want to prepare $diskmodel ($disksize) for BitLocker?" -ForegroundColor Yellow -BackgroundColor Red
                $confirmation = Read-Host "( Y / N )"
                switch ($confirmation) 
                {
                    Y 
                    {
                        Clear-Host
                        Write-Host "Preparing drive $diskmodel ($disksize) for BitLocker." -ForegroundColor Green; $prep = $true
                        Start-Sleep -Seconds 1 
                    }
                    N 
                    {
                        Clear-Host
                        Write-Host "No, leave $diskmodel ($disksize) alone." -ForegroundColor Red; $prep = $false
                        Start-Sleep -Seconds 1
                    }  
                    Default 
                    {
                        Clear-Host
                        Write-Host "No, leave $diskmodel ($disksize) alone." -ForegroundColor Red; $prep = $false
                        Start-Sleep -Seconds 1
                    }
                }
                if ($prep = $true)
                {
                    New-Item -Name disk.txt -ItemType file -Force | Out-Null
                    Add-Content -Path disk.txt "SEL DISK $diskid"
                    Add-Content -Path disk.txt "SEL PART 1"
                    Add-Content -Path disk.txt "INACTIVE"
                    $diskprep | Out-Null
                    Write-Host "Drive $diskmodel ($disksize) is now ready for BitLocker encryption!" -ForegroundColor Green
                    Remove-Item -path disk.txt -force
                    ++$counter
                }
                else 
                {
                    Write-Host "Drive $diskmodel ($disksize) has not been modified. BitLocker encryption may fail if there are any active MBR partitions on the disk" -ForegroundColor Red
                }
            }
    }
    if ($counter -gt 0)
    {
        Write-Host "$counter USB drive(s) have been prepared for BitLocker Encryption! Nice!" -ForegroundColor Green
    }
    else 
    {
       Write-Host "No USB drives have been prepared for BitLocker. Exiting" -ForegroundColor Red 
    }
