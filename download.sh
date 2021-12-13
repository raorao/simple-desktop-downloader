#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# content when you pass --help
#/ Usage: ./download.sh --start 5000 --end 65000
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }

# logging setup.
readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $@" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $@" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $@" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $@" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }


# cleanup regardless of error.
cleanup() {
  :
}

trap cleanup EXIT

start=6500
end=6501

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      usage
      shift
      ;;
    -s|--start)
      start=$2
      shift
      shift
      ;;
    -e|--end)
      end=$2
      shift
      shift
      ;;
    *)
      echo "unrecognized flag ${1}. see --help for available options."
      exit 1
      ;;
  esac
done

echo "$end $start"

mkdir -p images
info "created $(pwd)/images directory"

info "downloading images between ${start} and ${end}"

for i in $(seq $start $end)
do
  curl -L -s "http://simpledesktops.com/download/?desktop=$i" -o "images/$i.jpg"

  if [ $(wc -l < "images/$i.jpg") -eq 82  ]
  then
    rm "images/$i.jpg"
    info "skipping ${i}.jpg"
  else
    info "created ${i}.jpg"
  fi
done

#
