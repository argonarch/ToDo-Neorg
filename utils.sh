#!/bin/bash
source "$(dirname "$0")/colors.sh"

arrow=$Green"->"$Nc
todoClick=$Green" "$Nc 
todoNone=$Red" "$Nc
todoProcess=$Yellow" "$Nc
charA=$Yellow"A"$Nc
charB=$Green"B"$Nc
charC=$Blue"C"$Nc
charD=$Red"D"$Nc
champ="$Green|$Nc"


filter(){
  if [ "$PRIORITY_FILTER" == "none" ] || [ "$PRIORITY_FILTER" == "n" ]; then
    PRIORITY_FILTER=" "
  fi

  if [ "$TYPE_FILTER" == "none" ] || [ "$TYPE_FILTER" == "n" ]; then
    TYPE_FILTER=" "
  elif [ "$TYPE_FILTER" == "done" ] || [ "$TYPE_FILTER" == "d" ]; then
    TYPE_FILTER="x"
  elif [ "$TYPE_FILTER" == "process" ] || [ "$TYPE_FILTER" == "p" ]; then
    TYPE_FILTER="-"
  fi

  if [ "$DUET_FILTER" == "none" ] || [ "$DUET_FILTER" == "n" ]; then
    DUET_FILTER="  "
  fi

}
