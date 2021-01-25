

# if no arguements are provided.
if [ $# -lt 1 ]; then
    echo -e "This script uses required input values including ...

    ${bold}${underline}action${reset}: Options are apply or delete.
    "
    exit 128
fi


ACTION=$1
if [ -z "$ACTION" ]; then
    ACTION="apply"
fi
if [ $ACTION != "apply" ] && [ $ACTION != "delete" ]; then
    echo "Unknow command provided '$ACTION'. Use 'apply' or 'delete'."
    exit 0
fi
