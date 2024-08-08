#!/bin/bash
source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/utils.sh"

tempFile=$(mktemp)
newFile=$(mktemp)

scanner(){
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

scanProject(){
  input_file="$1"
  filename=" > $(basename "$1" .norg | sed -e 's/\([a-z]\)\([A-Z]\)/\1 \2/g' -e 's/^\(.\)/\U\1/g') <"
  echo -e "$filename" >> "$tempFile"
  grep -e "- (" "$input_file" | sed 's/( ) |/(Z) |/ ' | sort | sed 's/(Z) |/( ) |/'  >> "$tempFile"
}

processDate(){ 
  fv=$(echo "$1" | grep -oP '(?<=~)\d{4}-\d{2}-\d{2}')
  if [[ -n "$fv" ]]; then
    f_actual=$(date +%F)
    f_final=$(date -d "$f_actual + $DATE_FILTER" +%F)
    f_start=$(date -d "$f_actual" +%s)
    f_end=$(date -d "$f_final" +%s)
    f_scan=$(date -d "$fv" +%s)
    if [[ "$f_scan" -ge "$f_start" ]] && [[ "$f_scan" -le "$f_end" ]]; then
      echo "$1" >> "$2"
    fi
  else
    echo "$1" >> "$2"
  fi
}


