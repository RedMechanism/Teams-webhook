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

'''
Repository: awl-inc/awl-box-manager-website
Workflow: PHP CI
Duration: 27.0 seconds
Finished: 2020-02-27 02:47:13 UTC
'''
color = None

if CI_STATUS.lower() == 'failure':
    color = 'red'
elif CI_STATUS.lower() == 'cancelled':
    color = 'gray'
elif CI_STATUS.lower() == 'success':
    color = 'green'
else:
    color = 'blue'

myTeamsMessage.title(f'''Run Github Action CI/CD for {BRANCH}''')
# Add text to the message.
myTeamsMessage.text(f'''
    Status: <strong style="color: {color};">{CI_STATUS.upper() if CI_STATUS else ''}</strong> \t
    Repository: {REPOSITORY} \t
    Event: {EVENT} \t
    Workflow: {WORK_FLOW} \t
    Author: {ACTOR} \t
    Job: {JOB_NAME if JOB_NAME else 'Finish CI/CD'} \t
    Finished: {datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")} UTC
''')
# myTeamsMessage.printme()

# send the message.
myTeamsMessage.send()
EOF

echo $which-team
python3 end_message.py
