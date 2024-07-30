#!/bin/bash
source "$(dirname "$0")/colors.sh"
#todoClick=${Green}" "${Nc} 
#todoNone=${Red}" "${Nc}
#todoProcess=${Yellow}" "${Nc}
#charA=${Yellow}"A"${Nc}
#charB=${Green}"B"${Nc}
#charC=${Blue}"C"${Nc}
#charD=${Red}"D"${Nc}
#arrow=${Green}"->"${Nc}
#champ="${Green}|${Nc}"

scanProject(){
  input_file="$1"
  filename=$(basename "$1" .norg)
  filename_transform="$(echo "$filename" | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g')"
  filename_transform="$(tr '[:lower:]' '[:upper:]' <<< ${filename_transform:0:1})${filename_transform:1}"
  filename_final=" > $filename_transform < "
  while IFS= read -r line
  do
    if [[ $line == *"- ("* ]]; then
       processTasks "$line" "$filename_final" "$2"
    fi
  done < "$input_file"
}
processTasks(){ 

  if [[ -n "$DATE_FILTER" ]]; then 
    fv=$(echo "$1" | grep -oP '(?<=~)\d{4}-\d{2}-\d{2}')
    if [[ -n "$fv" ]]; then
      f_actual=$(date +%F)
      f_final=$(date -d "$f_actual + $DATE_FILTER" +%F)
      f_start=$(date -d "$f_actual" +%s)
      f_end=$(date -d "$f_final" +%s)
      f_scan=$(date -d "$fv" +%s)
      if [[ "$f_scan" -ge "$f_start" ]] && [[ "$f_scan" -le "$f_end" ]]; then
        if [ "$2" != "$nameFile" ]; then
        echo -e "\n$2" >> "$3"
        fi
        nameFile=$2
        echo -e "$1" >> "$3"
      fi
    fi
  else
    # Imprimir las variables
    if [ "$2" != "$nameFile" ]; then
      echo -e "\n$2" >> "$3"
      #echo -e "\n$2"
    fi
    nameFile=$2
    echo -e "$1" >> "$3"
  fi
}

scanProjectDefined(){
  scanProject "${!1}"
}

