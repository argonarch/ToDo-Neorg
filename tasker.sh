#!/bin/bash
source "$(dirname "$0")/scanner.sh"
source "$(dirname "$0")/order.sh"

scanFolder(){
  [ -n "$PROJECT_FILTER" ] && scanDefined && exit 0
  name=$(basename "$ROOT_FOLDER")
  echo -e "$arrow $name:"

  find "$ROOT_FOLDER" -type f -name "*.norg" | while IFS= read -r file; do
  [ -s "$file" ] && scanProject "$file" 
  done

  scanner 
}

scanDefined(){
  find "$ROOT_FOLDER" -type f -name "$PROJECT_FILTER.norg" | while IFS= read -r file; do
  [ -s "$file" ] && scanProject "$file" 
  done
  scanner
}

scanFile() {
  [ -n "$ADD_TEXT" ] && addTask && exit 0
  scanProject "$ROOT_FILE" 
  scanner 
}

listProjects(){ 
  name=$(basename "$ROOT_FOLDER")
  echo -e "- $name: -"
  counter=0
  find "$ROOT_FOLDER" -type f -name "*.norg" | while IFS= read -r file; do
    filename=$(basename "$file" .norg)
    counter=$((counter+1))
    if [ "$counter" -gt 9 ]; then
      echo -e "$counter $arrow $filename"
    else
      echo -e "$counter  $arrow $filename"
    fi
  done
}

addTask(){
  priority="( )"
  type="( )"
  due="|  |"
  context=""
  date=""

  [ -n "$PRIORITY_FILTER" ] && priority="($PRIORITY_FILTER)"
  [ -n "$TYPE_FILTER" ] && type="($TYPE_FILTER)"
  [ -n "$DUET_FILTER" ] && due="|$DUET_FILTER|"
  [ -n "$CONTEXT_FILTER" ] && context="@$CONTEXT_FILTER"
  [ -n "$DATE_FILTER" ] && date="~$DATE_FILTER"

  echo "- $type $priority $due $ADD_TEXT $context $date" >> "$ROOT_FILE"
  order
}
