

_mainScript_() {

  if [ $ACTION = "apply" ]; then
    echo ${bold}"Applying resources in organization [$ORG]..."${reset}
    if topicExists $TOPIC; then
      echo "Topic [$TOPIC] already exists."
    else
      gcloud pubsub topics create $TOPIC --labels $LABELS
      gcloud pubsub subscriptions create $SUBSCRIPTION --topic $TOPIC --labels $LABELS
      gcloud pubsub topics add-iam-policy-binding projects/$PROJECT_ID/topics/$TOPIC --member "serviceAccount:"$SA_ACCOUNT --role $SA_ROLE_PUBSUB  > /dev/null
      gcloud organizations add-iam-policy-binding $ORG --member "serviceAccount:"$SA_ACCOUNT --role $SA_ROLE_SCC  > /dev/null

      # create NotificationConfig for DLP (filter)
      CFG_DLP_NAME="dlp_config"
      CFG_DLP_DESC="dlp_service_notification_config"
      CFG_DLP_FILTER="state=\"ACTIVE\""

      gcloud scc notifications create $CFG_DLP_NAME \
        --organization $ORG \
        --description $CFG_DLP_DESC \
        --pubsub-topic "projects/$PROJECT_ID/topics/$TOPIC" \
        --filter $CFG_DLP_FILTER
    fi
  else
    echo ${bold}"Removing resources..."${reset}
    gcloud pubsub subscriptions delete $SUBSCRIPTION
    deleteTopic $TOPIC 1
  fi

  echo ${bold}"Script complete."${reset}

} # end _mainScript_