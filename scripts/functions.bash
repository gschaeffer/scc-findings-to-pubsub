

function isValidEmail() {
      regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
      [[ "${1}" =~ $regex ]]
}


# ----------------------------------
# PUBSUB STUFF :)
# ----------------------------------

function deleteTopic(){
    # ARGS (IN ORDER): 
    #   1 = TOPIC
    #   2 = DELETE_SUBSCRIPTIONS, 1 or 0
    # echo "ARGS are [$*]"
    if topicExists $1; then
        if subscriptionExistsInTopic $1 $SUBSCRIPTION; then
            deleteSubscription $1 $SUBSCRIPTION
        fi
      gcloud pubsub topics delete $1
    else
      echo "Topic [$1] does not exist. Nothing to delete."
    fi
}

function topicExists(){
    # ARGS (IN ORDER): 
    #   1 = TOPIC
    # result=$(gcloud pubsub topics list | grep $1)
    FILTER="name:projects/$PROJECT_ID/topics/$1"
    result=$(gcloud pubsub topics list --filter=$FILTER)
    if $result > 0; then
        return 1
    else
        return 0
    fi
}

function subscriptionExistsInTopic(){
    # ARGS (IN ORDER): 
    #   1 = TOPIC
    #   2 = SUBSCRIPTION
    result=$(gcloud pubsub topics list-subscriptions $1 | grep $2)
    if $result > 0; then
        return 1
    else
        return 0
    fi
}

function deleteSubscription(){
    # ARGS (IN ORDER): 
    #   1 = TOPIC
    #   2 = SUBSCRIPTION
    # echo "ARGS are [$*]"
    if subscriptionExistsInTopic $1 $2; then
      gcloud pubsub subscriptions delete $2
    else
      echo "Subscription [$2] does not exist. Nothing to delete."
    fi
}