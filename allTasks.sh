#!/bin/bash
source colors.sh
source projectTasks.sh
root_folder="../1_Proyectos/"
root_folder2="../2_Areas/"

todoNona="${Red} ${Nc}"
arrow=${Green}"->"${Nc}
archivo="pathProjects.sh"
getAllTasks(){
# Usar find para listar todos los archivos y luego cat para obtener su contenido
if [ -n "$ROOT_FOLDER" ]; then
  echo -e "$arrow $ROOT_FOLDER:"
  scanAll "../$ROOT_FOLDER"
else
  echo -e "$arrow Proyectos:"
  scanAll "$root_folder"
  echo
  echo -e "$arrow Areas:"
  scanAll "$root_folder2"
fi
}


listAllProjects(){
  echo "Proyectos:"
  find "$root_folder" -type f -name "*.norg" | while IFS= read -r file; do
    filename=$(basename "$file" Task.norg)
    echo -e "$arrow $filename"
  done
}

scanAll(){
  tempFile=$(mktemp)
  newFile=$(mktemp)
  find "$1" -type f -name "*.norg" | while IFS= read -r file; do
  if [ -n "$PROJECT_DEFINED" ]; then 
    filename=$(basename "$file" Task.norg)
    if [ "$filename" == "$PROJECT_DEFINED" ]; then
      scanProject "$file" "$tempFile"
    else
      continue  
    fi
  elif [ -s "$file" ]; then
    scanProject "$file" "$tempFile"
  fi
  done

  if [[ -n "$TYPE_FILTER" ]]; then
    sed -n "/- ($TYPE_FILTER)/p; / >.*</p" $tempFile  > $newFile
    cat $newFile > $tempFile
  fi
  if [[ -n "$PRIORITY_FILTER" ]]; then
    sed -n "/) ($PRIORITY_FILTER) /p; / >.*</p" $tempFile  > $newFile
    cat $newFile > $tempFile
  fi
  if [[ -n "$GOAL_FILTER" ]]; then
    sed -n "/ |$GOAL_FILTER| /p; / >.*</p" $tempFile  > $newFile
    cat $newFile > $tempFile
  fi
  if [[ -n "$DATE_FILTER" ]]; then 

    start_date=$(date +%F)
    end_date=$(date -d "$f_actual + $DATE_FILTER" +%F)
    
    # Convert dates to seconds since epoch
    start_ts=$(date -d "$start_date" +%s)
    end_ts=$(date -d "$end_date" +%s)

    # Initialize an empty array
    dates=()

    # Loop from start date to end date
    current_ts=$start_ts
    while [ $current_ts -le $end_ts ]; do
        # Convert the current timestamp back to date
        current_date=$(date -d "@$current_ts" +%F)
        # Append the date to the array
        dates+=("$current_date")
        # Move to the next day (add 86400 seconds)
        current_ts=$(($current_ts + 86400))
    done
    allDates=$(echo "${dates[@]}" | sed 's/\([^ ]*\)/\/ ~\1\/p;/g')

    sed -n "/ ~.*/p; / >.*</p" $tempFile  > $newFile
    cat $newFile > $tempFile

    sed -n "$allDates / >.*</p" $tempFile  > $newFile
    cat $newFile > $tempFile
  fi


  sed -i "/ >.*</s/^/\n/" $newFile

  awk '
  BEGIN { RS=""; FS="\n" }
  />.*</ && !/) \|/ { next }
  { print }
  ' $newFile > $tempFile

  sed -i "s/ >/\n >/g" $tempFile
  sed -i "s/|\(.*\)|/--> \1 |/g" $tempFile
  sed -i "s/- ( )/ /g" $tempFile
  sed -i "s/- (x)/ /g" $tempFile
  sed -i "s/- (-)/ /g" $tempFile
  sed -i "s/ (A) / A /g" $tempFile
  sed -i "s/ (B) / B /g" $tempFile
  sed -i "s/ (C) / C /g" $tempFile
  sed -i "s/ (D) / D /g" $tempFile
  sed -i "s/ ( ) /   /g" $tempFile
  cat "$tempFile"   

}
