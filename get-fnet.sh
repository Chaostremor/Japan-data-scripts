#!/bin/sh

# download fnet data, then convert from format win to w1 with tool win32tow1

USER="chaostremor"
PASS="songchao1993"
UA="Firefox"      
 # "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:36.0) Gecko/20100101 Firefox/36.0"
CN="c615b265d5dbd6df743c764c51d17331"

#cd hinet/

for line in `cat trig_time`
do 
  YY=`echo "${line}" | awk '{print substr($1,1,4)}'`
  mo=`echo "${line}" | awk '{print substr($1,5,2)}'`
  day=`echo "${line}" | awk '{print substr($1,7,2)}'`

#for YY in "2009" #`seq 2010 1 2013`
#do
YY2=`echo "${YY}" | awk '{print substr($1,3,2)}'`
#for mo in "5" #`seq 1 1 12`
#do
MM=`awk 'BEGIN{x='${mo}';printf "%02d",x}'`
#for day in "10" #`seq 1 1 31`
#do
DD=`awk 'BEGIN{x='${day}';printf "%02d",x}'`
if [ ! -d ${YY2}${MM}${DD}/ ];then
mkdir ${YY2}${MM}${DD}/
fi
cd ${YY2}${MM}${DD}/

for hour in `seq 0 1 23` #`seq 0 1 23`
do
HH=`awk 'BEGIN{x='${hour}';printf "%02d",x}'`

#NYY=`date -j -f'%Y/%m/%d %H:%M:%S' -v+60M "${YY}/${MM}/${DD} ${HH}:00:00" +'%Y%m%d%H%M%S' | awk '{print substr($1,1,4)}'`
#NMM=`date -j -f'%Y/%m/%d %H:%M:%S' -v+60M "${YY}/${MM}/${DD} ${HH}:00:00" +'%Y%m%d%H%M%S' | awk '{print substr($1,5,2)}'`
#NDD=`date -j -f'%Y/%m/%d %H:%M:%S' -v+60M "${YY}/${MM}/${DD} ${HH}:00:00" +'%Y%m%d%H%M%S' | awk '{print substr($1,7,2)}'`
#NHH=`date -j -f'%Y/%m/%d %H:%M:%S' -v+60M "${YY}/${MM}/${DD} ${HH}:00:00" +'%Y%m%d%H%M%S' | awk '{print substr($1,9,2)}'`
fn="01_03_${YY}${MM}${DD}${HH}00_60.tar.gz"
SPAN="60"

#wget "http://"${USER}":"${PASS}"@www.hinet.bosai.go.jp/REGS/download/cont/cont_request.php?org1=01&org2=01&year="${YY}"&month="${MM}"&day="${DD}"&hour="${HH}"&min=00&span=60&arc=GZIP" -O tmp.html

# login
PD="org=NIED&net=0103&year=${YY}&month=${MM}&day=${DD}&hour=${HH}&min=${MM}&span=${SPAN}&LANG=ja&arc=GZIP&search_btn=%B0%CA%BE%E5%A4%CE%BE%F2%B7%EF%A4%C7%A5%C7%A1%BC%A5%BF%A4%F2%B8%A1%BA%F7&auth_un=${USER}&auth_pw=${PASS}"
URL="https://hinetwww11.bosai.go.jp/auth/download/cont/"
wget --user-agent=''${UA}'' --post-data=''${PD}'' --keep-session-cookies --no-check-certificate --header='Host: hinetwww11.bosai.go.jp' --header='Referer: https://hinetwww11.bosai.go.jp/auth/?LANG=ja' --header='Cookie: _ssl_auth='${CN}'' ${URL} -O tmp.html

# data request
PD="auth_un=${USER}&auth_pw=${PASS}"
rand=`date "+%s %N" | awk '{printf "%10.0f\n",$1*1000+$2/1000000}'`
POST="org1=01&org2=03&year=${YY}&month=${MM}&day=${DD}&hour=${HH}&min=00&span=${SPAN}&arc=GZIP&size=1440&LANG=ja&volc=0&rn=${rand}"
URL="https://hinetwww11.bosai.go.jp/auth/download/cont/cont_request.php"
wget --user-agent=''${UA}'' -t 1 --timeout 180 --no-check-certificate --keep-session-cookies --post-data=''${PD}'' -O tmp2.html ${URL}?${POST} --header='Host: hinetwww11.bosai.go.jp' --header='Referer: https://hinetwww11.bosai.go.jp/auth/?LANG=ja' --header='Cookie: _ssl_auth='${CN}''

# get ID list
URL="https://hinetwww11.bosai.go.jp/auth/download/cont/cont_status.php"
wget --user-agent=''${UA}'' --no-check-certificate --keep-session-cookies --post-data=''${PD}'' -O tmp3.html ${URL} --header='Host: hinetwww11.bosai.go.jp' --header='Referer: https://hinetwww11.bosai.go.jp/auth/?LANG=ja' --header='Cookie: _ssl_auth='${CN}''

ID=`grep ${YY}/${MM}/${DD} tmp3.html | head -1 | awk -F\> '{print $3}' | awk -F\< '{print $1}'`
echo "${ID}"
sleep 30

# download
URL="https://hinetwww11.bosai.go.jp/auth/download/cont/cont_download.php?id=${ID}&LANG=ja"
wget -t 50 --user-agent=''${UA}'' --no-check-certificate --keep-session-cookies --post-data=''$PD'' -O ${YY}${MM}${DD}${HH}.tgz ${URL} --header='Host: hinetwww11.bosai.go.jp' --header='Referer: https://hinetwww11.bosai.go.jp/auth/?LANG=ja' --header='Cookie: _ssl_auth='${CN}''

# delete data on the server
URL="https://hinetwww11.bosai.go.jp/auth/download/cont/cont_delete.php?id=${ID}"
wget --user-agent=''${UA}'' --no-check-certificate --keep-session-cookies --post-data=''${PD}'' -O tmp4.html ${URL} --header='Host: hinetwww11.bosai.go.jp' --header='Referer: https://hinetwww11.bosai.go.jp/auth/?LANG=ja' --header='Cookie: _ssl_auth='${CN}''


tar zxvf ${YY}${MM}${DD}${HH}.tgz

#tar -xzf ${YY}${MM}${DD}${HH}.tgz

cat < /dev/null > ${YY2}${MM}${DD}${HH}.00
for fncnt in `ls ${YY}${MM}${DD}${HH}????????.cnt`
do

../w32tow1 ${fncnt} tmp.win
cat tmp.win >> ${YY2}${MM}${DD}${HH}.00
rm ${fncnt}
done

rm 01_03_${YY}${MM}${DD}.sjis.ch
rm readme.txt
rm tmp.html
rm tmp2.html
rm tmp3.html
rm tmp4.html
rm tmp.win
#rm ${fn}
rm ${YY}${MM}${DD}${HH}.tgz

done

cd ../
#done
#done
done


