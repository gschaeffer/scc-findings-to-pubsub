

_mainScript_() {

  CFG_NAME="default_config"-$PROJECT_ID

  if [ $ACTION = "apply" ]; then
    echo ${bold}"Applying resources in organization [$ORG]..."${reset}
    if topicExists $TOPIC; then
      echo "Topic [$TOPIC] already exists."
    else
      gcloud pubsub topics create $TOPIC --labels $LABELS
      gcloud pubsub subscriptions create $SUBSCRIPTION --topic $TOPIC --labels $LABELS
      gcloud pubsub topics add-iam-policy-binding projects/$PROJECT_ID/topics/$TOPIC --member "serviceAccount:"$SA_ACCOUNT --role $SA_ROLE_PUBSUB  > /dev/null
      gcloud organizations add-iam-policy-binding $ORG --member "serviceAccount:"$SA_ACCOUNT --role $SA_ROLE_SCC  > /dev/null

      # create NotificationConfig (filter)
      CFG_DESC="scc_notifications_2_alerts_config"
      CFG_FILTER="state=\"ACTIVE\""

      gcloud scc notifications create $CFG_NAME \
        --organization $ORG \
        --description $CFG_DESC \
        --pubsub-topic "projects/$PROJECT_ID/topics/$TOPIC" \
        --filter $CFG_FILTER
    fi
  else
    echo ${bold}"Removing resources..."${reset}
    gcloud pubsub subscriptions delete $SUBSCRIPTION
    deleteTopic $TOPIC 1
    gcloud scc notifications delete $CFG_NAME --organization $ORG 
  fi

  echo ${bold}"Script complete."${reset}

} # end _mainScript_
