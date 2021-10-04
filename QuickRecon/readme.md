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

## Decrypting Firefox Stored Passwords

If the loot includes Firefox data, you can decrypt the ky database to recover stored usernames and passwords for websites.
Download and install the following github repo:
https://github.com/unode/firefox_decrypt
If you don't already have Python3 install that as well.
Then, in terminal/shell: python firefox_decrypt.py /folder/containing/profile/

Still working on how to do this with Chrome... hope to have that solved in v3.0

## Status

| LED              | Status                                |
| ---------------- | ------------------------------------- |
| Amber blinking   | Attack in progress                    |
| Green            | Attack Finished                       |

## Updates

Updated to version 2.0.  Firefox profile data is now read in to a variable so that specific data can be copied.