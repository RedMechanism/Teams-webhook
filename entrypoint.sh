#!/bin/sh

cat << EOF > ms_teams_notification.py
#!/usr/bin/python3
import pymsteams
import os
from datetime import datetime, timedelta

# You must create the connectorcard object with the Microsoft Webhook URL

WEB_HOOK_URL = os.getenv('webhook_url', None)
REPOSITORY_NAME = os.getenv('repository_name', None)
REPOSITORY_URL = os.getenv('repository_url', None)
EVENT = os.getenv('event', None)
JOB_STATUS = os.getenv('job_status', '')
BRANCH = os.getenv('branch', None)
JOB_NAME = os.getenv('job_name', None)
ACTOR = os.getenv('actor', None)
PR_NUMBER = os.getenv('pr_number', None)
RUN_ID = os.getenv('run_id', None)
if WEB_HOOK_URL is None:
    print("Please set WEB_HOOK_URL env")
    exit(1)

myTeamsMessage = pymsteams.connectorcard(WEB_HOOK_URL)

color = None

if JOB_STATUS.lower() == 'failure':
    color = 'red'
elif JOB_STATUS.lower() == 'cancelled':
    color = 'gray'
elif JOB_STATUS.lower() == 'success':
    color = 'green'
else:
    color = 'blue'

myMessageSection = pymsteams.cardsection()

myTeamsMessage.title(f'''{REPOSITORY_NAME}''')

myTeamsMessage.addSection(myMessageSection)
# Activity Elements
myMessageSection.activityTitle("On branch: "+BRANCH)
myMessageSection.activitySubtitle("Triggered by: "+ACTOR)
myMessageSection.activityImage("https://github.com/"+ACTOR+".png")
JST_time = datetime.now() + timedelta(hours = 9)
myMessageSection.activityText(JST_time.strftime("%Y-%m-%d %H:%M:%S"))

# Facts are key value pairs displayed in a list.
myMessageSection.addFact("Status:", "<strong style='color: {textcolor}';>{Result}</strong>".format(textcolor = color, Result = JOB_STATUS.upper()))
myMessageSection.addFact("Job:", JOB_NAME)
myMessageSection.addFact("Event:", EVENT)

# Add text to the message.
myTeamsMessage.text(f'''
''')
myTeamsMessage.color("Red")
myTeamsMessage.addLinkButton("Go to workflow", "https://github.com/"+REPOSITORY_URL+"/actions/runs/"+RUN_ID+"?check_suite_focus=true")
myTeamsMessage.addLinkButton("Go to pull request", "https://github.com/"+REPOSITORY_URL+"/pulls/"+PR_NUMBER)
myTeamsMessage.send()
EOF

python3 ms_teams_notification.py
