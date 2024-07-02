function consensusHandler {
  echo beforeAsync
  sleep 5
  echo afterAsync
}

echo before
consensusHandler & 
echo after
sleep 10
echo afterSleep
