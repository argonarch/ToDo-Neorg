#!/bin/bash
source colors.sh
todoClick=${Green}" "${Nc} 
todoNone=${Red}" "${Nc}
todoProcess=${Yellow}" "${Nc}
charA=${Yellow}"A"${Nc}
charB=${Green}"B"${Nc}
charC=${Blue}"C"${Nc}
charD=${Red}"D"${Nc}
arrow=${Green}"->"${Nc}
champ="${Green}|${Nc}"

scanProject(){
  input_file="$1"
  filename=$(basename "$1" Task.norg)
  filename_transform="$(echo "$filename" | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g')"
  filename_transform="$(tr '[:lower:]' '[:upper:]' <<< ${filename_transform:0:1})${filename_transform:1}"
  filename_final="${Cyan} > $filename_transform < ${Nc}"
  while IFS= read -r line
  do
    if [[ $line == *"- ("* ]]; then
       processTasks "$line" "$filename_final" "$2"
    fi
  done < "$input_file"
}
processTasks(){  
  if [ "$2" != "$nameFile" ]; then
    echo -e "\n$2" >> "$3"
  fi
  nameFile=$2
  echo -e "$1" >> "$3"
}

scanProjectDefined(){
  scanProject "${!1}"
}

