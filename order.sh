#!/bin/bash

orderTask(){
  input_file="$1"
  output_file=$(mktemp)

  # Limpiar archivo de salida si ya existe
  true > "$output_file"

  tareaBloque "- Tareas Incompletas:"   "( )" "$input_file" "$output_file" 

  tareaBloque "\n- Tareas En Proceso:"  "(-)" "$input_file" "$output_file"

  tareaBloque "\n- Tareas Completadas:" "(x)" "$input_file" "$output_file" 
  
  tareaBloque "\n- Tareas Archivadas:"  "(?)" "$input_file" "$output_file"
 
  echo -e "\n- No Tareas:" >> "$output_file" 
  while IFS= read -r line
  do
    if [[ ! $line =~ -\ \(.*\) ]] && [[ $line != *"Tareas"* ]] && [[ -n $line ]]; then
      echo "$line" >> "$output_file"
    fi
  done < "$input_file"

  mv "$output_file" "$input_file"
}
 
tareaBloque(){
  echo -e "$1" >> "$4"
  grep -e "- $2" "$3" | sed 's/( ) |/(Z) |/ ' | sort | sed 's/(Z) |/( ) |/'  >> "$4"
}

order(){
  if [ -n "$ROOT_FOLDER" ]; then
    find "$ROOT_FOLDER" -type f -name "*.norg" | while read -r file
    do
      orderTask "$file"
    done
  else
    echo "No exist root folder"
  fi
}
