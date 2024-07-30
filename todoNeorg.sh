#!/bin/bash
source "$(dirname "$0")/allTasks.sh"
source "$(dirname "$0")/projectTasks.sh"
source "$(dirname "$0")/order.sh"
main(){
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--type)
          if [ -n "$2" ]; then
            if [ "$2" == "none" ] || [ "$2" == "n" ]; then
              TYPE_FILTER=" "
            elif [ "$2" == "done" ]; then
              TYPE_FILTER="x"
            elif [ "$2" == "process" ]; then
              TYPE_FILTER="-"
            else
              TYPE_FILTER="$2"
            fi
            shift 2
          else
            echo "Uso: -t <type>"
          fi
          ;;
      -c|--context)
          if [ -n "$2" ]; then
            CONTEXT_FILTER="$2"
            shift 2
          else
            echo "Uso: -c <context>"
          fi
          ;;
      -e|--due)
          if [ -n "$2" ]; then
            if [ "$2" == "none" ] || [ "$2" == "n" ]; then
              DUE_FILTER="  "
            else
              DUE_FILTER="$2"
            fi
            shift 2
          else
            echo "Uso: -d <due>"
          fi
          ;;
      -p|--priority)
          if [ -n "$2" ]; then
            if [ "$2" == "none" ] || [ "$2" == "n" ]; then
              PRIORITY_FILTER=" "
            else
              PRIORITY_FILTER="$2"
            fi
            shift 2
          else
            echo "Uso: -p <priority>"
          fi
          ;;
      -s|--scan)
          if [ -n "$2" ]; then
            PROJECT_DEFINED="$2"
            shift 2
          else
            echo "Uso: -s <project>"
          fi
          ;;
      -d|--date)
          if [ -n "$2" ]; then
            DATE_FILTER="$2"
            shift 2
          else
            echo "Uso: -d <date>"
          fi
          ;;
      -r|--root)
          if [ -n "$2" ]; then
            ROOT_FOLDER="$2"
            shift 2
          else
            echo "Uso: -r <folder>"
          fi
          ;;
      -o|--order)
          orderTasks
          exit 0
          ;;
      -l|--list)
          listAllProjects
          exit 0
          ;;
      -a|--all)
          getAllTasks
          exit 0
          ;;
    esac
  done
  if [ -n "$TYPE_FILTER" ] || [ -n "$PRIORITY_FILTER" ] || [ -n "$PROJECT_DEFINED" ] || [ -n "$ROOT_FOLDER" ] || [ -n "$DATE_FILTER" ] || [[ -n "$DUE_FILTER" ]] || [[ -n "$CONTEXT_FILTER" ]]; then
    getAllTasks 
  fi
}

main "$@"
