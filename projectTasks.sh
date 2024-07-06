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
       if [[ $? -eq 1 ]]; then
         continue        
       fi
    fi
  done < "$input_file"
}
processTasks(){ 
  # todo=$(echo "$1" | grep -oP "\- \(\K[^)]")
  # time=$(echo "$1" | grep -oP " \|\K[^| ]{2}")
  # priority=$(echo "$1" | grep -oP "\) \(\K[^)]")
  #
  # text=$(echo "$1" | sed -n 's/.*| //p' | sed 's/ ~.*//g')
  # fv=$(echo "$1" | grep -oP "(?<=~)\d{4}-\d{2}-\d{2}")
   
  # if [ "$todo" == "x" ]; then
  #   newTodo=$todoClick
  # elif [ "$todo" == "-" ]; then
  #   newTodo=$todoProcess
  # else
  #   newTodo=$todoNone
  # fi
  #
  # if [ "$priority" == "A" ]; then
  #   newPriority=$charA
  # elif [ "$priority" == "B" ]; then
  #   newPriority=$charB
  # elif [ "$priority" == "C" ]; then
  #   newPriority=$charC
  # elif [ "$priority" == "D" ]; then
  #   newPriority=$charD
  # else
  #   newPriority=" "
  # fi
  # 
  # if [[ -n "$DATE_FILTER" ]] && [[ -n "$fv" ]]; then
  #   f_actual=$(date +%F)
  #   f_final=$(date -d "$f_actual + $DATE_FILTER" +%F)
  #   f_start=$(date -d "$f_actual" +%s)
  #   f_end=$(date -d "$f_final" +%s)
  #   f_scan=$(date -d "$fv" +%s)
  #   if [ "$f_scan" -lt "$f_start" ] || [ "$f_scan" -gt "$f_end" ]; then
  #     return 1
  #   fi
  # elif [[ -n "$DATE_FILTER" ]] && [[ -z "$fv" ]]; then
  #   return 1
  # fi

  # if [[ -n "$PRIORITY_FILTER" ]] && [[ "$priority" != "$PRIORITY_FILTER" ]]; then
  #   return 1
  # fi
  #
  # if [[ -n "$TYPE_FILTER" ]] && [[ "$todo" != "$TYPE_FILTER" ]] ; then
  #   return 1
  # fi
  #
  # if [[ -n "$GOAL_FILTER" ]] && [[ "$time" != "$GOAL_FILTER" ]]; then
  #   return 1
  # fi

  # if [ "$time" == "" ]; then
  #   time="  "
  # fi
  
  # Imprimir las variables
  if [ "$2" != "$nameFile" ]; then
    echo -e "\n$2" >> "$3"
    #echo -e "\n$2"
  fi
  nameFile=$2
  #echo -e "$newTodo $newPriority $arrow $time $champ $text ${Green}$fv${Nc}" 
  echo -e "$1" >> "$3"
}

scanProjectDefined(){
  scanProject "${!1}"
}

