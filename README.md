<h1 align="center">
<img src="img/alert1b.png" alt="SCC Alerts">
<br>SCC Notifications to Alerts
</h1>
<p align="center">
  <a href="#features">Features</a> •
    <a href="#requirements">Requirements</a> •
  <a href="#installation">Installation</a>
</p>


## Features

This Security Command Center (SCC) Notifications project extends the default behavior of SCC Findings to add the ability to setup Alerts using Cloud Monitoring.

The behavior of SCC Findings occurs at the GCP Organization level. Through normal SCC operations, findings are generated and viewable in the SCC dashboard. Because these activities happen at the Organization level, they are not available in Cloud Monitoring to setup Metrics & Alerts. 

Google documentation does provide a means to capture Findings into PubSub, [1] https://cloud.google.com/security-command-center/docs/how-to-notifications. From PubSub we can do just about anything with scripting and configuration.

This project (scripts) attempts to both simplify the setup and make the notifications available in Cloud Monitoring so that standard GCP features may be used for reporting or Alerts. It does this though scripts to accomplish

- Automate the setup and removal of SCC Notifications to PubSub into your project
- Logging the Findings into your project, making the data available to Cloud Logging and Cloud Monitoring
- Minimizing custom scripting and using standard GCP features where available
- Removes or reduces the need for any custom scripts to be created

![diagram](img/scc_notifications.png)

## Requirements

To run the scripts you will need the following.

- Organization ID
- Project ID - where the resources will be installed
- Service Account - a service account for SCC Notifications to run
- Security Command Center API must be enabled
- You will need IAM security roles of 
  - Security Center Admin - to setup notifications
  - Organization Admin - to setup the service account with needed roles

## Installation

### Clone the repository 

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fgschaeffer%2Fscc_alerts&cloudshell_git_branch=main)

Clone the repo to Cloud Shell.
Optionally, clone to a VM or your local machine if you prefer.
`git clone https://github.com/gschaeffer/scc_notifications`

#### Edit variables

Edit script variables in the setup.sh file. You must edit the organization id, project id, and service account values. The remaining variables are optional.

`ORG="YOUR_GCP_ORGANIZATION_ID
PROJECT_ID="YOUR_PROJECT_ID"
SA_ACCOUNT="YOUR_SERVICE_ACCOUNT"`

#### Run setup

First, we install the SCC Notifications to PubSub as provided by Google [1 above].  Use the setup.sh command which automates this process.

`./setup.sh apply`

This creates only the resources as described in the SCC Notifications doc [1]. At this point you should begin seeing notifications being sent to the PubSub topic.

If you need to remove the resources installed use the same setup command with `delete` argument.

`./setup.sh delete`

#### Add a Cloud Function

Second, to Findings events available in Cloud Monitoring, install the provided Cloud Function. This will  to begin sending Findings from PubSub to Cloud Logging & Cloud Monitoring.

`./functions/deploy_logger_func.sh`

This will install a very simple Python function that will be triggered by findings being added to the PubSub Topic. After installing you should begin seeing log entries in Cloud Logging. These entries are logged into it's own log named *scc_notifications_log* for easy search. 

With the Findings in Cloud Logging all the normal tools are available to setup Metrics and Alerts, https://cloud.google.com/monitoring/alerts. 

