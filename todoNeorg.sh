#!/bin/bash
source allTasks.sh
source projectTasks.sh
source order.sh
main(){
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--type)
          if [ -n "$2" ]; then
            if [ "$2" == "none" ]; then
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
      -g|--goal)
          if [ -n "$2" ]; then
            if [ "$2" == "none" ]; then
              GOAL_FILTER="  "
            else
              GOAL_FILTER="$2"
            fi
            shift 2
          else
            echo "Uso: -g <goal>"
          fi
          ;;
      -p|--priority)
          if [ -n "$2" ]; then
            if [ "$2" == "none" ]; then
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
  if [ -n "$TYPE_FILTER" ] || [ -n "$PRIORITY_FILTER" ] || [ -n "$PROJECT_DEFINED" ] || [ -n "$ROOT_FOLDER" ] || [ -n "$DATE_FILTER" ] || [[ -n "$GOAL_FILTER" ]]; then
    getAllTasks 
  fi
}

main "$@"
