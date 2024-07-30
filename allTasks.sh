#!/bin/bash
source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/projectTasks.sh"

arrow=${Green}"->"${Nc}
getAllTasks(){
# Usar find para listar todos los archivos y luego cat para obtener su contenido
if [ -n "$ROOT_FOLDER" ]; then
  name=$(basename "$ROOT_FOLDER")
  echo -e "$arrow $name:"
  scanAll "$ROOT_FOLDER"
else
  echo -e "Root File Dont Exist"
fi
}


listAllProjects(){
if [ -n "$ROOT_FOLDER" ]; then
  name=$(basename "$ROOT_FOLDER")
  echo -e "- $name: -"
  find "$ROOT_FOLDER" -type f -name "*.norg" | while IFS= read -r file; do
    filename=$(basename "$file" .norg)
    echo -e "$arrow $filename"
  done
else
  echo -e "Root File Dont Exist"
fi

}

scanAll(){
  tempFile=$(mktemp)
  newFile=$(mktemp)
  find "$1" -type f -name "*.norg" | while IFS= read -r file; do
  if [ -n "$PROJECT_DEFINED" ]; then 
    filename=$(basename "$file" .norg)
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
    sed -n "/- ($TYPE_FILTER)/p; / >.*</p" "$tempFile"  > "$newFile"
    cat "$newFile" > "$tempFile"
  fi
  if [[ -n "$PRIORITY_FILTER" ]]; then
    sed -n "/) ($PRIORITY_FILTER)/p; / >.*</p" "$tempFile"  > "$newFile"
    cat "$newFile" > "$tempFile"
  fi
  if [[ -n "$DUE_FILTER" ]]; then
    sed -n "/ |$DUE_FILTER|/p; / >.*</p" "$tempFile"  > "$newFile"
    cat "$newFile" > "$tempFile"
  fi
  if [[ -n "$CONTEXT_FILTER" ]]; then
    sed -n "/@$CONTEXT_FILTER/p; / >.*</p" "$tempFile"  > "$newFile"
    cat "$newFile" > "$tempFile"
  fi
  if [[ -n "$DATE_FILTER" ]]; then 
    sed -n "/ ~.*/p; / >.*</p" "$tempFile"  > "$newFile"
    cat "$newFile" > "$tempFile"
  fi

  sed -i "/ >.*</s/^/\n/" "$newFile"

  awk '
  BEGIN { RS=""; FS="\n" }
  />.*</ && !/) \|/ { next }
  { print }
  ' "$newFile" > "$tempFile"
  sed -i "s/ >/\n >/g" "$tempFile"  

  sed -i "s/|\(.*\)|/--> \1 |/g" "$tempFile"
  sed -i "s/- ( )/ /g" "$tempFile"
  sed -i "s/- (x)/ /g" "$tempFile"
  sed -i "s/- (-)/ /g" "$tempFile"
  sed -i "s/ (A) / A /g" "$tempFile"
  sed -i "s/ (B) / B /g" "$tempFile"
  sed -i "s/ (C) / C /g" "$tempFile"
  sed -i "s/ (D) / D /g" "$tempFile"
  sed -i "s/ ( ) /   /g" "$tempFile"
  cat "$tempFile"  

}
