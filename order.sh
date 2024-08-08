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
  noTareas "\n- No Tareas" "$input_file" "$output_file"

  mv "$output_file" "$input_file"
}
 
tareaBloque(){
  echo -e "$1" >> "$4"
  grep -e "- $2" "$3" | sed 's/( ) |/(Z) |/ ' | sort | sed 's/(Z) |/( ) |/'  >> "$4"
}

noTareas(){
  echo -e "$1" >> "$3"
  while IFS= read -r line
  do
    [[ ! $line =~ -\ \(.*\) ]] && [[ $line != *"Tareas"* ]] && [[ -n $line ]] && echo "$line" >> "$3"
  done < "$2"
}

order(){
  if [ -n "$ROOT_FOLDER" ]; then
    find "$ROOT_FOLDER" -type f -name "*.norg" | while read -r file
    do
      orderTask "$file"
    done
  elif [ -n "$ROOT_FILE" ]; then
    orderTask "$ROOT_FILE" 
  else
    echo "No exist root folder"
  fi
}
