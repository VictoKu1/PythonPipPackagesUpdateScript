#!/bin/bash
echo "Prepearing....."
sleep 1.5s
pip freeze > requirements.txt
python3 PythonPipPackagesUpdateScript/change.py requirements.txt "==" ">="
clear
lines=$(wc -l requirements.txt | awk '{print $1}')
echo "Started updating requirements.txt"
sleep 2.5s
clear
timeOfStart=$(date +%s)
commands=()
for ((counter=1; counter<=lines; counter++))
    do
        line=$(sed -n "${counter}p" requirements.txt)
        timeNow=$(date +%s)
        timeWorking=$((timeNow-timeOfStart))
        commands+=("clear;echo \"Progress: $((counter*100/lines))%, $((counter)) packages done, $((lines-counter)) packages remaining of total $((lines)) packages.\";pip install --upgrade $line;echo \"\"")
        echo "Progress: $((counter*100/lines))%."
        clear
    done
echo "Starting packages updating"
parallel --jobs 10 ::: "${commands[@]}"
wait
rm -rf requirements.txt
echo "Update completed successfully."
sleep 1s
clear
