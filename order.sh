#!/bin/bash

orderTask(){
  input_file="$1"

  # Archivo de salida
  output_file=$(mktemp)

  # Limpiar archivo de salida si ya existe
  true > "$output_file"

  # Tareas Incompletas 
  echo -e "- Tareas Incompletas:" >> "$output_file"

  while IFS= read -r line
  do
      if [[ $line == *"- ( )"* ]]; then
          echo "$line" >> "$output_file"
      fi
  done < "$input_file"

  # Tareas en Proceso
  echo -e "\n- Tareas En Proceso:" >> "$output_file"

  while IFS= read -r line
  do
      if [[ $line == *"- (-)"* ]]; then
          echo "$line" >> "$output_file"
      fi
  done < "$input_file"

  # Taras Completadas 
  echo -e "\n- Tareas Completadas:" >> "$output_file"
  
  while IFS= read -r line
  do
      if [[ $line == *"- (x)"* ]]; then
          echo "$line" >> "$output_file"
      fi
  done < "$input_file"
  

  # Tareas Archivadas 
  echo -e "\n- Tareas Archivadas:" >> "$output_file"

  while IFS= read -r line
  do
      if [[ $line == *"- (?)"* ]]; then
          echo "$line" >> "$output_file"
      fi
  done < "$input_file"
  
 
  # No Tareas  
  echo -e "\n- No Tareas:" >> "$output_file"
  
  while IFS= read -r line
  do
    if [[ ! $line =~ -\ \(.*\) ]] && [[ $line != *"Tareas"* ]] && [[ -n $line ]]; then
      echo "$line" >> "$output_file"
    fi
  done < "$input_file"

  mv "$output_file" "$input_file"
}

orderTasks(){
if [ -n "$ROOT_FOLDER" ]; then
  order "$ROOT_FOLDER"
else
  echo -e "Root File Dont Exist"
fi
}
order(){
  find "$1" -type f -name "*.norg" | while read -r file
  do
    orderTask "$file"
  done
}
