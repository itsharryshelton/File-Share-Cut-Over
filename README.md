# FileShareCutOver
A script to check, remove legacy share, then add new server share.

====
**How it works: **

Firstly, it will check if the PC targeted will reach the server at all, if it can't it will write to host it can't, and provide you with their current IP config.
If it can, it will do the following:
Find existing old drive, use the drive letter to remove it, then use that same drive letter to map the new drive share.
Force Restarts File Explorer to ensure the GUI updates with this change, as Windows seems to get stuck displaying the old version, then output the IP config.

**What you need to do: **

Edit the following:
$ipAddress - Change this to your server address
Line 28 - Swap to old share address
Line 40 - Swap to old share address
Line 47 Swap to NEW share address

If you're running this via an RMM, make sure the script is ran with signed in user credentials, not system level, otherwise this won't work.

**What it can't do: **

If the user does not have the credentials already there, it MAY NOT add or prompt for the user to type credentials, I've tested it working like 65-75% of time it will ask for credentials, other times it will just stall out.

Can NOT be run at system level, Windows does not report any net use information from a user when you run something as system/root level - like an RMM Tool

====
