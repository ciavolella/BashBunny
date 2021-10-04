# QuickRecon for the BashBunny

## Description

Gather a lot of information about the computer and place it in \loot\QuickRecon\.

This payload will run a full file and folder tree of the %USERPROFILE% folder
and a tree of the folders in %USERPROFILE%\AppData (which isn't pulled by default because it is hidden).
This info is dumped in recon.txt file the \loot\QuickRecon\ directory.
A ton of information about the computer, including wifi SSIDs and passwords is also grabbed 
and dumped to a text file in the \loot\QuickRecon\ folder.
Finally the user's browser data (history, bookmarks, etc) is dumped to a series of corresponding folders in \loot\QuickRecon\

Even on computers with a lot of browser data, this shouldn't take much longer than 15 seconds.

## Viewing Browser Databases

I use DB Browser for SQLite.  You can open the browser database files, and export the relevant tables to csv files.

## Decrypting Browser Stored Passwords

There are a few ways to do this, but the simplest is using WebBrowerPassView from nirsoft (nirsoft.net).  You can point the program to the /loot/QuickRecon folder on the BashBunny and it will automatically pull the passwords stored in the databses.

## Status

| LED              | Status                                |
| ---------------- | ------------------------------------- |
| Amber blinking   | Attack in progress                    |
| Green            | Attack Finished                       |

## Updates

Updated to version 2.0.  Firefox profile data is now read in to a variable so that specific data can be copied.
