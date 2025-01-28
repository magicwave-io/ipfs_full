if [[ "${no_conf}" != "1" ]]; then
   bash init.sh
fi
function mark {
  match=$1
  file=$2
  mark=1
  while read -r data; do
    echo $data
    if [[ $data == *"$match"* ]]; then 
      if [[ "$mark" == "1" ]]; then 
        echo "done" >> $file
        mark=0
      fi
    fi
  done
}
if [ $# -eq 0 ]
then
    /opt/paidpiper/ipfs daemon | mark "Daemon is ready" ".ipfs_ready"
else 
    exec "$@" | mark "Daemon is ready" ".ipfs_ready"
fi
