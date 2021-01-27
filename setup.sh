#!/bin/bash

# ----------------------------------
# DESC
# Setup SCC notifications to PubSub. 
#   https://cloud.google.com/security-command-center/docs/how-to-notifications
#   https://cloud.google.com/security-command-center/docs/how-to-api-manage-notifications
# 
# Requirements
#   Role: Security Center Admin is needed to setup Notifications
#   Role: Security Center Admin Viewer is needed to access SCC dashboard
#   Role: Organization Administator to be able to setup service-account with needed roles
#   API: Security Command Center API must be enabled
# 
# Components (to be created)
#   Service Account: create SA and grant role that contains permissions for
#   - pubsub.topics.setIamPolicy: 'PubSub Admin' or custom role
#   - securitycenter.notification: securitycenter,notificationConfigEditor or securitycenter.admin
#   PubSub Topic and Subscription
# ----------------------------------


# ----------------------------------
# SET CONFIG'S/VARIABLES HERE...
# ----------------------------------
ORG="976583563296"
APP="scc-notifications"
PROJECT_ID="scc-alerts-001"
TOPIC="scc-notifications"
SUBSCRIPTION="scc-notifications"

SA_ACCOUNT="scc-alerts@scc-alerts-001.iam.gserviceaccount.com"
SA_ROLE_PUBSUB="roles/pubsub.admin"
SA_ROLE_SCC="roles/securitycenter.notificationConfigEditor"

# Appended to label 'created_by' key.
USER="bash_script"
LABELS="app=$APP,created_by=$USER"


# ----------------------------------
# DONT EDIT BELOW
# ----------------------------------
source scripts/utils.bash
source scripts/args.bash
source scripts/main.bash
source scripts/functions.bash

_mainScript_
