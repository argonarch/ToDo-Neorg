#!/bin/bash
source "$(dirname "$0")/styles.sh"
source "$(dirname "$0")/utils.sh"

tempFile=$(mktemp)
newFile=$(mktemp)

scanner(){
  apply_filter "$TYPE_FILTER" "- ($TYPE_FILTER)" "$newFile" "$tempFile"
  apply_filter "$PRIORITY_FILTER" ") ($PRIORITY_FILTER)" "$newFile" "$tempFile"
  apply_filter "$DUET_FILTER" " |$DUET_FILTER|" "$newFile" "$tempFile"
  apply_filter "$CONTEXT_FILTER" " @$CONTEXT_FILTER" "$newFile" "$tempFile"
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

scanFolder(){
  [ -n "$PROJECT_FILTER" ] && scanDefined && exit 0
  name=$(basename "$ROOT_FOLDER")
  echo -e "$arrow $name:"

  find "$ROOT_FOLDER" -type f -name "*.norg" | while IFS= read -r file; do
  [ -s "$file" ] && scanProject "$file" 
  done

  scanner 
}

scanDefined(){
  find "$ROOT_FOLDER" -type f -name "$PROJECT_FILTER.norg" | while IFS= read -r file; do
  [ -s "$file" ] && scanProject "$file" 
  done
  scanner
}

scanFile() {
  [ -n "$ADD_TEXT" ] && addTask && exit 0
  scanProject "$ROOT_FILE" 
  scanner 
}

scanProject(){
  input_file="$1"
  filename=" > $(basename "$1" .norg | sed -e 's/\([a-z]\)\([A-Z]\)/\1 \2/g' -e 's/^\(.\)/\U\1/g') <"
  echo -e "$filename" >> "$tempFile"
  grep -e "- (" "$input_file" | sed 's/( ) |/(Z) |/ ' | sort | sed 's/(Z) |/( ) |/'  >> "$tempFile"
}



