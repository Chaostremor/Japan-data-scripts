#!/bin/sh

#set TDAY = 090510
#set DIR = ./090510

for line in `cat trig_time`
do 
  YY=`echo "${line}" | awk '{print substr($1,1,4)}'`
  mo=`echo "${line}" | awk '{print substr($1,5,2)}'`
  day=`echo "${line}" | awk '{print substr($1,7,2)}'`

YY2=`echo "${YY}" | awk '{print substr($1,3,2)}'`

MM=`awk 'BEGIN{x='${mo}';printf "%02d",x}'`

DD=`awk 'BEGIN{x='${day}';printf "%02d",x}'`

cd ${YY2}${MM}${DD}

rm -f tmp.win

cat ${YY2}* > tmp.win
grep -v '^#' 01_01_20${YY2}${MM}${DD}.euc.ch | ../wintosac tmp.win 01_01_20${YY2}${MM}${DD}.euc.ch

cd ../

done



