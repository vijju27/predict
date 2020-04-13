#!/bin/bash

let fetch_success=1
declare -a satellites_list
readarray satellites_list < list.txt

#already files unnay vatini delete cheyali leda override cheyali. NOTE: override avvatle, wget tho concatinate avtunnay so removing ye option
echo "Fetching updates"
rm -f amateur.txt
rm -f visual.txt
rm -f weather.txt

#if condition lo == pedithe correct output ratle
echo -n "Amateur "
wget -qr www.celestrak.com/NORAD/elements/amateur.txt -O amateur.txt
if [ $? -eq 0 ]; then 
	echo "OK"
else
	echo "FAIL"
	fetch_success=0
fi


echo -n "Visual "
wget -qr www.celestrak.com/NORAD/elements/visual.txt -O visual.txt
if [ $? -eq 0 ]; then 
	echo "OK"
else
	echo "FAIL"
	fetch_success=0
fi


echo -n "Weather "
wget -qr www.celestrak.com/NORAD/elements/weather.txt -O weather.txt
if [ $? -eq 0 ]; then 
	echo "OK"
else
	echo "FAIL"
	fetch_success=0
fi


echo "$fetch_success"
if [ $fetch_success -eq 1 ]; then
 	rm -f all.tle
	cat amateur.txt visual.txt weather.txt >> all.tle
	predict -u all.tle
	echo "FETCH SUCCESS"
else
	echo "FETCH FAILED"
fi

#test.tle file ni delete chesi malli create cheyali
rm -f test.tle
touch test.tle

#NORAD with U tho unna line 2 line la undi so okka line extra kavali so 1 add cheyali and last 3 lines ni extract cheyali prati NORAD ID ki
let temp=0
for i in "${satellites_list[@]}"
do
	temp=$(grep -n -m 1 $i all.tle | cut -d: -f 1)
	temp=$((temp+1))
	head -n $temp all.tle | tail -n 3 >> test.tle
done

