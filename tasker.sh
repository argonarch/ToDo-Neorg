#!/bin/bash
source "$(dirname "$0")/order.sh"


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

sendTask(){
  tasks=$(grep -E "\+\w+" "$ROOT_FILE")
  while IFS= read -r task; do
    project=$(echo "$task" | grep -oP '(?<=\+).*?(?=\s|$)')
    find "$ROOT_FOLDER" -type f -name "$project.norg" | while IFS= read -r file; do
      taskWP=$(echo "$task" | sed 's/\+.[^ ]* *//')
      echo "$taskWP" >> "$file"
      orderTask "$file"
      sed -i "/$task/d" "$ROOT_FILE"
    done
  done <<< "$tasks"
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
