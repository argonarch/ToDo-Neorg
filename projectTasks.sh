#!/bin/bash
source "$(dirname "$0")/colors.sh"

scanProject(){
  input_file="$1"
  filename=" > $(basename "$1" .norg | sed -e 's/\([a-z]\)\([A-Z]\)/\1 \2/g' -e 's/^\(.\)/\U\1/g') <"
  echo -e "$filename" >> "$2"
  grep -e "- (" "$input_file" | sed 's/( ) |/(Z) |/ ' | sort | sed 's/(Z) |/( ) |/'  >> "$2"
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

scanProjectDefined(){
  scanProject "${!1}"
}

