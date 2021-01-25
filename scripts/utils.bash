


# ----------------------------------
# Date helpers
# ----------------------------------
now=$(LC_ALL=C date +"%m-%d-%Y %r")                   # Returns: 06-14-2015 10:34:40 PM
datestamp=$(LC_ALL=C date +%Y-%m-%d)                  # Returns: 2015-06-14
hourstamp=$(LC_ALL=C date +%r)                        # Returns: 10:34:40 PM
timestamp=$(LC_ALL=C date +%Y%m%d_%H%M%S)             # Returns: 20150614_223440
today=$(LC_ALL=C date +"%m-%d-%Y")                    # Returns: 06-14-2015
longdate=$(LC_ALL=C date +"%a, %d %b %Y %H:%M:%S %z") # Returns: Sun, 10 Jan 2016 20:47:53 -0500
gmtdate=$(LC_ALL=C date -u -R | sed 's/\+0000/GMT/')  # Returns: Wed, 13 Jan 2016 15:55:29 GMT


# ----------------------------------
# Colors
# ----------------------------------
if tput setaf 1 &>/dev/null; then
  bold=$(tput bold)
  white=$(tput setaf 7)
  reset=$(tput sgr0)
  purple=$(tput setaf 171)
  red=$(tput setaf 1)
  green=$(tput setaf 76)
  tan=$(tput setaf 3)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 38)
  underline=$(tput sgr 0 1)
else
  bold="\033[4;37m"
  white="\033[0;37m"
  reset="\033[0m"
  purple="\033[0;35m"
  red="\033[0;31m"
  green="\033[1;32m"
  tan="\033[0;33m"
  yellow="\033[0;33m"
  blue="\033[0;34m"
  underline="\033[4;37m"
fi


# ----------------------------------
# Interaction
# ----------------------------------
_seekConfirmation_() {
  # DESC:  Seek user input for yes/no question
  # ARGS:   $1 (Optional) - Question being asked
  # OUTS:   true/false
  # USAGE:  _seekConfirmation_ "Do something?" && echo "okay" || echo "not okay"
  #         OR
  #         if _seekConfirmation_ "Answer this question"; then
  #           something
  #         fi
  input "${1-}"
  if "${force}"; then
    verbose "Forcing confirmation with '--force' flag set"
    echo -e ""
    return 0
  else
    while true; do
      read -r -p " (y/n) " yn
      case $yn in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
        *) input "Please answer yes or no." ;;
      esac
    done
  fi
}