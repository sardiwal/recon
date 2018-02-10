#!/usr/bin/env bash
set +x
cd /home/manishasangwan47
#read -p 'URL: ' url
#echo > new.txt
#echo > /home/manishasangwan47/$name_dir.txt
echo > /home/manishasangwan47/temp.txt
#echo > /home/manishasangwan47/"$name"_open_ports.csv
for url in appsecure.in #twitter.com uber.com yahoo.com
do
        name=`echo $url |cut -d "." -f1`
        echo "$name"
        touch /home/manishasangwan47/$name.txt
        touch /home/manishasangwan47/temp.txt
        touch /home/manishasangwan47/"$name"_dir.txt
        touch /home/manishasangwan47/"$name"_open_ports.txt
	touch /home/manishasangwan47/"$name"_nikto.txt
        path=/home/manishasangwan47/$name.txt
        temp=/home/manishasangwan47/temp.txt
        cd Sublist3r
        python sublist3r.py -v -d $url > $path
        echo "running sublister $ur"
        grep $url $path | cut -d ":" -f2 | sed 's/ //g' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g" > /home/manishasangwan47/final_subdomains.txt
        cd ..
        cd dnscan
        python dnscan.py -d $url -o response.txt
        echo "DNS scan $url"
        grep $url response.txt | grep -v "Processing" | grep -v "Scanning" | grep -v "include" | cut -d "-" -f2 | sed 's/ //g' | sort |uniq >> /home/manishasangwan47/final_subdomains.txt
        cd ..
        cat  final_subdomains.txt | grep -v "#401-or-403-Unauthorized-header"|grep -v "#Content-Management-System-header"|grep -v "Enumeratingsubdomainsnowfor" | sort |uniq > $temp
        rm /home/manishasangwan47/final_subdomains.txt
        # file="$name".txt
        # while IFS= read line
        # do
        # if grep "$line" "$name"_old.txt > /dev/null; then
        #     echo "\t"
        # else
        #    echo "$line +++ $url"
        #    if $line -eq $url > /dev/null; then
        #         echo "\t"
        #     else
        #         echo "$line" >> new.txt
        #     fi
        # fi
        # done <"$file"
        # cat new.txt >> "$name"_old.txt
        # rm $name.txt
        cd EyeWitness
        python EyeWitness.py -f $temp -d screens --headless
        awk '/Uncategorized/{flag=1;next}/404 Not Found/{flag=0}flag' /home/manishasangwan47/EyeWitness/screens/report.html |grep '<a href="'  | cut -d '"' -f2 | grep -v "source"| grep -v "screens"|sort | uniq|cut -d "/" -f3 > /home/manishasangwan47/"$name".txt
        #cp /home/manishasangwan47/EyeWitness/screens/report.html /home/manishasangwan47/"$name".html
        # cp /home/manishasangwan47/EyeWitness/screens/open_ports.csv /home/manishasangwan47/"$name"_open_ports.csv
	cd ..
        nmap -iL /home/manishasangwan47/"$name".txt > /home/manishasangwan47/"$name"_open_ports.txt
 
	echo "" >> /home/manishasangwan47/"$name".txt
        
	cd /opt/dirb
	for line in $(cat /home/manishasangwan47/"$name".txt); do
        url=https://"$line"
        ./dirb $url wordlists/common.txt >> /home/manishasangwan47/"$name"_dir.txt
        done

	cd /opt/nikto/
	for line in $(cat /home/manishasangwan47/"$name".txt); do
		perl nikto.pl -h "$name" > /home/manishasangwan47/"$name"_nikto.txt
	done

	cd /home/manishasangwan47/
        
	python send_mail.py /home/manishasangwan47/"$name".txt /home/manishasangwan47/"$name"_open_ports.txt /home/manishasangwan47/"$name"_dir.txt  /home/manishasangwan47/"$name"_nikto.txt "$name"_report
	rm /home/manishasangwan47/temp.txt
	rm "$name"*
done
