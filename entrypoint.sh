#!/bin/sh

cat << EOF > send_message.py
#!/usr/bin/python3
import pymsteams
import os
from datetime import datetime

# You must create the connectorcard object with the Microsoft Webhook URL

WEB_HOOK_URL = os.getenv('WEB_HOOK_URL', None)
REPOSITORY = os.getenv('REPOSITORY', None)
EVENT = os.getenv('EVENT', None)
WORK_FLOW = os.getenv('WORK_FLOW', None)
CI_STATUS = os.getenv('CI_STATUS', '')
BRANCH = os.getenv('BRANCH', None)
JOB_NAME = os.getenv('JOB_NAME', None)
ACTOR = os.getenv('ACTOR', None)


if WEB_HOOK_URL is None:
    print("Please set WEB_HOOK_URL env")
    exit(1)

myTeamsMessage = pymsteams.connectorcard(WEB_HOOK_URL)

color = None

if CI_STATUS.lower() == 'failure':
    color = 'red'
elif CI_STATUS.lower() == 'cancelled':
    color = 'gray'
elif CI_STATUS.lower() == 'success':
    color = 'green'
else:
    color = 'blue'

myTeamsMessage.title(f'''CI/CD on {REPOSITORY}''')
# Add text to the message.
myTeamsMessage.text(f'''
    Status: <strong style="color: {color};">{CI_STATUS.upper() if CI_STATUS else ''}</strong> \t
    Branch: <a href='http://google.com' style="color: {color};>{BRANCH}</a> \t
    Event: {EVENT} \t
    Workflow: {WORK_FLOW} \t
    Actor: {ACTOR} \t
    Job: {JOB_NAME if JOB_NAME else 'Finish CI/CD'} \t
    Date: {datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")}
''')
# myTeamsMessage.printme()

# send the message.
myTeamsMessage.send()
EOF

echo $which-team
python3 send_message.py
