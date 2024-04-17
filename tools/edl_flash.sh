#!/bin/bash -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
ROOT=$DIR/..

EDL=$ROOT/edl/edl

echo "in here"

setactiveslot() {
  if [ "$1" == "a" ]; then
    BOOT_LUN="1"
  elif [ "$1" == "b" ]; then
    BOOT_LUN="2"
  else
    echo "Active slot must be \"a\" or \"b\""
  fi

  echo "Setting slot $1 active..."
  {
    $EDL setactive $1
    $EDL setbootablestoragedrive $BOOT_LUN
  } &> /dev/null
}


flash() {
  $EDL w $1 $2 --memory=ufs
}
