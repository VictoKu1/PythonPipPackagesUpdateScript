echo "Prepearing....."
sleep 1.5s
pip freeze > requirements.txt
python change.py  requirements.txt "==" ">="
clear
lines=$(wc -l requirements.txt | awk '{print $1}')
counter=0
echo "Started updating requirements.txt"
sleep 2.5s
clear
timeOfStart=$(date +%s)
while [ $counter -lt $lines ]
do
    line=$(sed -n "${counter}p" requirements.txt)
    counter=$((counter+1))
    timeNow=$(date +%s)
    timeWorking=$((timeNow-timeOfStart))
    echo "Progress: $((counter*100/lines))%, currently package $counter of $lines packages, $((lines-counter)) remaining, time working: $(date -d@$timeWorking -u +%H:%M:%S)."
    pip install --upgrade $line
    clear
done
rm -rf requirements.txt
echo "Update completed ."
sleep 1s
clear