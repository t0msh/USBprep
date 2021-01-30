# usbprep
```
 _____ _____ _____                 
|  |  |   __| __  |___ ___ ___ ___ 
|  |  |__   | __ -| . |  _| -_| . |
|_____|_____|_____|  _|_| |___|  _|
                  |_|         |_|      
```
A tool for IT admins that enforce BitLocker Encryption removable drives and have a lot of removable USB media.

## Why?
In September 2020 with [KB4577069](https://support.microsoft.com/en-us/topic/september-16-2020-kb4577069-os-build-17763-1490-preview-fcc63e7f-dbf1-ab01-9a11-1f79983e8526) Microsoft changed Bitlocker behaviour to stop the encryption of any filesystems that are on an active MBR drive. That's great and all, but almost all USB drives come as active.

Below is an excerpt from the changelog for [KB4577069](https://support.microsoft.com/en-us/topic/september-16-2020-kb4577069-os-build-17763-1490-preview-fcc63e7f-dbf1-ab01-9a11-1f79983e8526)

> Changes BitLocker behavior by preventing you from using BitLocker on file systems that are on an active master boot record (MBR) drive. When you attempt to use BitLocker on active MBR drives, you might see the following:
> * “ERROR: The volume X: could not be opened by BitLocker. This may be because the volume does not exist, or because it is not a valid BitLocker volume.”
> * “The drive cannot be encrypted because it contains system boot information……”

*"No problem, i'll just use `DISKPART` to do a `CLEAN` and then format the drive!"* I hear you say! Sure, at home, when you're the boss, and you can elevate priviliges willy-nilly! The thing is, the type of organisations that enforce the encryption of removable drives aren't in the habit of letting their users go wild with system tools. This means IT have to do it. **One by one**.

The organization I work at goes through a fair drives each week, and our field engineers have better things to be doing than getting hounded with requests to "make the disk work" each time they attend a job for something else. I mashed together this little PoSh, to make the process a bit quicker. When our weekly delivery of 200 new USB flash drives arrives, I can plug in as many as USB ports I have, and get them all ready to be used and encrypted with BitLocker. 

## Usage
This script isn't meant for non-admin users as it requires elevated permissions.

1. Launch an Admin Powershell window
2. Navigate to wherever you stored the script
3. Run the script with `.\usbprep.ps1` 
4. Follow the instructions

## What it does
* Finds all the USB drives currently plugged in
* Confirms if you want to do the thing
* Launches `DISKPART` with the `/s` flag to pull it's commands from a file.
* Makes the partition on the USB drive `INACTIVE`
* Cleans up the text file that it makes for `DISKPART`
## What it doesn't do
* Encrypt your USB drives
* Get around any UAC restrictions
* Delete any data
* Solve the problem Microsoft introduced