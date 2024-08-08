#!/bin/bash
source "$(dirname "$0")/tasker.sh"
source "$(dirname "$0")/order.sh"
source "$(dirname "$0")/sender.sh"
source "$(dirname "$0")/utils.sh"

main(){
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--type)
          [ -n "$2" ] && TYPE_FILTER="$2" && FILTER="true" && shift 2 ;;
      -c|--context)
          [ -n "$2" ] && CONTEXT_FILTER="$2" && FILTER="true" && shift 2 ;;
      -e|--due)
          [ -n "$2" ] && DUET_FILTER="$2" && FILTER="true" && shift 2 ;;
      -p|--priority)
          [ -n "$2" ] && PRIORITY_FILTER="$2" && FILTER="true" && shift 2 ;;
      -P|--project)
          [ -n "$2" ] && PROJECT_FILTER="$2" && FILTER="true" && shift 2 ;;
      -d|--date)
          [ -n "$2" ] && DATE_FILTER="$2" && FILTER="true" && shift 2 ;;
      -a|--add)
          [ -n "$2" ] && ADD_TEXT="$2" && shift 2 ;;
      -r|--root)
          [ -n "$2" ] && ROOT_FOLDER="$2" && shift 2 ;;
      -f|--file)
          [ -n "$2" ] && ROOT_FILE="$2" && shift 2 ;;
      -o|--order)
          order
          exit 0 ;;
      -s|--sender)
          sender
          exit 0 ;;
      -l|--list)
          listProjects
          exit 0 ;;
    esac
  done
  if [ -n "$ROOT_FOLDER" ] && [ -n "$FILTER" ]; then
    filter
    scanFolder
  elif [ -n "$ROOT_FILE" ] && [ -n "$FILTER" ]; then
    filter
    scanFile
  else  
    echo "Root File Dont Exist or Not Pass Any Filter"
  fi
}

main "$@"
