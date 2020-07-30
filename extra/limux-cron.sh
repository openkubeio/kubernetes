 while :; do
   currenttime=$(date +%H:%M)
   if [[ "$currenttime" > "23:00" ]] || [[ "$currenttime" < "23:05" ]]; then
     echo "do_something"
   else
     sleep 60
   fi
   test "$?" -gt 0 && notify_failed_job
  done