#!/bin/bash



function mark {
  match=$1
  file=$2
  mark=1
  while read -r data; do
    echo $data
    if [[ $data == *"$match"* ]]; then 
      if [[ "$mark" == "1" ]]; then 
        echo "done" >> $file
        #mark=0
      fi
    fi
  done
}
#sh echoer.sh | tee >(grep "ehco2" | head -1 | touch .done) | tee ./log.log 
#sh echoer.sh | tee >(head -1 1>&2) | tee ./log.log 
sh echoer.sh | mark "ehco2" ".done" | tee ./log.log 
