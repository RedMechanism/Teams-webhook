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
CI_STATUS = os.getenv('CI_STATUS', '')
BRANCH = os.getenv('BRANCH', None)
JOB_NAME = os.getenv('JOB_NAME', None)
ACTOR = os.getenv('ACTOR', None)
PR_NUMBER = os.getenv('PR_REF', None)


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

myMessageSection = pymsteams.cardsection()

myTeamsMessage.title(f'''{REPOSITORY}''')

myTeamsMessage.addSection(myMessageSection)
# Activity Elements
myMessageSection.activityTitle("On branch: ")
myMessageSection.activitySubtitle("Triggered by: {ACTOR}")
myMessageSection.activityImage("https://github.com/{ACTOR}.png")
myMessageSection.activityText(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

# Facts are key value pairs displayed in a list.
myMessageSection.addFact("Status: ", <strong style='color: {color};'>{CI_STATUS.upper() if CI_STATUS else ''}</strong>)
myMessageSection.addFact("Job:", "{JOB_NAME}")
myMessageSection.addFact("Event:", "{EVENT}")

# Add text to the message.
myTeamsMessage.text(f'''
''')
myTeamsMessage.color("Red")

myTeamsMessage.addLinkButton("PR_REF", "https://github.com/"{REPOSITORY}"/pull/"{PR_NUMBER})
myTeamsMessage.addLinkButton("Google", "https://github.com/rveachkc/pymsteams/")
myTeamsMessage.send()
EOF

echo $which-team
python3 send_message.py
