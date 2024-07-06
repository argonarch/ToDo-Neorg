#!/bin/bash




orderTask(){
  input_file="$1"

  # Archivo de salida
  output_file=$(mktemp)

  # Limpiar archivo de salida si ya existe
  > $output_file

  # Agregar encabezado para las tareas incompletas
  echo -e "Tareas Incompletas:\n" >> $output_file

  # Leer el archivo línea por línea y agregar tareas incompletas
  while IFS= read -r line
  do
      if [[ $line == *"- ( )"* ]]; then
          echo "$line" >> $output_file
      fi
  done < "$input_file"

  echo -e "\nTareas En Proceso:\n" >> $output_file

  # Leer el archivo línea por línea y agregar tareas incompletas
  while IFS= read -r line
  do
      if [[ $line == *"- (-)"* ]]; then
          echo "$line" >> $output_file
      fi
  done < "$input_file"
  # Agregar encabezado para las tareas completadas
  echo -e "\nTareas Completadas:\n" >> $output_file

  # Leer el archivo línea por línea y agregar tareas completadas
  while IFS= read -r line
  do
      if [[ $line == *"- (x)"* ]]; then
          echo "$line" >> $output_file
      fi
  done < "$input_file"
  
  echo -e "\nNo Tareas:\n" >> $output_file

  while IFS= read -r line
  do
    if [[ $line != *"- ( )"* ]] && [[ $line != *"- (x)"* ]] && [[ $line != *"- (-)"* ]] && [[ $line != *"Tareas"* ]] && [[ -n $line ]]; then
      echo "$line" >> $output_file
    fi
  done < "$input_file"

  mv $output_file $input_file
}

orderTasks(){
root_folder="../1_Proyectos/"
root_folder2="../2_Areas/"
order "$root_folder"
order "$root_folder2"
}
order(){
  find "$1" -type f -name "*.norg" | while read -r file
  do
    orderTask "$file"
  done
}
