#!/bin/bash

filter(){
  if [ "$PRIORITY_FILTER" == "none" ] || [ "$PRIORITY_FILTER" == "n" ]; then
    PRIORITY_FILTER=" "
  fi

  if [ "$TYPE_FILTER" == "none" ] || [ "$TYPE_FILTER" == "n" ]; then
    TYPE_FILTER=" "
  elif [ "$TYPE_FILTER" == "done" ] || [ "$TYPE_FILTER" == "d" ]; then
    TYPE_FILTER="x"
  elif [ "$TYPE_FILTER" == "process" ] || [ "$TYPE_FILTER" == "p" ]; then
    TYPE_FILTER="-"
  fi

  if [ "$DUET_FILTER" == "none" ] || [ "$DUET_FILTER" == "n" ]; then
    DUET_FILTER="  "
  fi

}

apply_filter() {
  local filter="$1"
  local pattern="$2"
  if [ -n "$filter" ]; then
    grep -e " >.*<" -e "$pattern" "$4" > "$3"
    mv "$3" "$4"
  fi
}

processDate(){ 
  fv=$(echo "$1" | grep -oP '(?<=~)\d{4}-\d{2}-\d{2}')
  if [[ -n "$fv" ]]; then
    f_actual=$(date +%F)
    f_final=$(date -d "$f_actual + $DATE_FILTER" +%F)
    f_start=$(date -d "$f_actual" +%s)
    f_end=$(date -d "$f_final" +%s)
    f_scan=$(date -d "$fv" +%s)
    if [[ "$f_scan" -ge "$f_start" ]] && [[ "$f_scan" -le "$f_end" ]]; then
      echo "$1" >> "$2"
    fi
  else
    echo "$1" >> "$2"
  fi
}
