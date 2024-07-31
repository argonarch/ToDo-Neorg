#!/bin/bash
source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/projectTasks.sh"

arrow=$Green"->"$Nc
todoClick=$Green" "$Nc 
todoNone=$Red" "$Nc
todoProcess=$Yellow" "$Nc
charA=$Yellow"A"$Nc
charB=$Green"B"$Nc
charC=$Blue"C"$Nc
charD=$Red"D"$Nc
champ="$Green|$Nc"

tempFile=$(mktemp)
newFile=$(mktemp)

listAllProjects(){
  name=$(basename "$ROOT_FOLDER")
  echo -e "- $name: -"
  counter=0
  find "$ROOT_FOLDER" -type f -name "*.norg" | while IFS= read -r file; do
    filename=$(basename "$file" .norg)
    counter=$((counter+1))
    if [ "$counter" -gt 9 ]; then
      echo -e "$counter $arrow $filename"
    else
      echo -e "$counter  $arrow $filename"
    fi
  done
}

scanAll(){
  name=$(basename "$ROOT_FOLDER")
  echo -e "$arrow $name:"

  find "$ROOT_FOLDER" -type f -name "*.norg" | while IFS= read -r file; do
  if [ -s "$file" ]; then
    scanProject "$file" "$tempFile"
  fi
  done

  apply_filter "$TYPE_FILTER" "- ($TYPE_FILTER)"
  apply_filter "$PRIORITY_FILTER" ") ($PRIORITY_FILTER)"
  apply_filter "$DUET_FILTER" " |$DUET_FILTER|"
  apply_filter "$CONTEXT_FILTER" " @$CONTEXT_FILTER"
  if [ -n "$DATE_FILTER" ]; then
    grep -e " >.*<" -e " ~.*" "$tempFile" > "$newFile"
    true > "$tempFile"
    while IFS= read -r line; do
      processDate "$line" "$tempFile"
    done < "$newFile"
  fi

  sed -i "/ >.*</s/^/\n/" "$tempFile"
  awk '
  BEGIN { RS=""; FS="\n" }
  />.*</ && !/) \|/ { next }
  { print }
  ' "$tempFile" > "$newFile"

  sed -i -e "s/ >/\n $BCyan>/g"  -e "s/ </ < $Nc/g" -e "s/|\(.*\)|/ $arrow \1 $champ/g" \
      -e "s/- ( )/$todoNone /g" -e "s/- (x)/$todoClick /g" -e "s/- (-)/$todoProcess /g" \
      -e "s/ (A) / $charA /g" -e "s/ (B) / $charB /g" -e "s/ (C) / $charC /g" -e "s/ (D) / $charD /g" \
      -e "s/ ( ) /   /g" "$newFile"
  cat "$newFile"
}

apply_filter() {
  local filter="$1"
  local pattern="$2"
  if [ -n "$filter" ]; then
    grep -e " >.*<" -e "$pattern" "$tempFile" > "$newFile"
    mv "$newFile" "$tempFile"
  fi
}
