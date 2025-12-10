json_out="/home/safi/cloud/network/output.json"

header() {
	timestamp=$(date '+%H:%M:%S %d-%m-%Y')
	echo " "
	echo "----$1----[$timestamp]----"
	echo " "
}
check_int() {
	header "Internet Connection Check"
	out=$(ping -c 1 -q google.com 2>&1)
	status=$?
	if [ $status -eq 0 ];then
		int_out="Internet Connection Stable"
		echo "[$timestamp]:[CHECK] Internet Connection Stable"
	else
		int_out="No Internet Connection"
		echo "[$timestamp]:[WARNING] No Internet Connection"
	fi
	echo " "
}
DNS_resolution() {
	header "DNS resolution"
	read -p "Enter the host name:" name
	out=$(host "$name" 2>&1)
    	DNS_out="$out"
	echo "[$timestamp]:[CHECK] DNS Resolution:"
	echo "$out"
	echo " "
}
ping_domain() {
	header "Ping Domain"
	read -p "Enter domain to ping:" dom
	out=$(ping -c 1 -q "$dom" 2>&1)
	if [ $? -eq 0 ]; then
		ping_out=$(ping -c 2 "$dom")
		echo "[$timestamp]:[CHECK] "
		echo "$ping_out"
	else
		ping_out="Domain Invalid"
		echo "Domain Invalid"
	fi
	echo " "
}
open_port() {
	header "Check if port Open/Close"
	echo "Type 'all' to see all open ports"
	read -p "Enter port number:" port
	if [ "$port" = "all" ]; then
		out1=$(ss -tulnp | tail -n +2 \
            | awk '{split($5,a,":"); print a[length(a)]}' \
            | sort -n -u 2>&1)
		port_out="$out1"
		echo "$out1"
	else 
		matches=$(ss -tulnp | tail -n +2 | awk -v p="$port" '{ split($5,a,":"); if (a[length(a)]==p) print }')
		if [ -n "$matches" ]; then
            		out2="Port $port: OPEN"
             		out3="$matches"
			port_out="$out2"
			port_out="$out3"
			echo "$out2"
			echo "$out3"
		else
			out4="Port $port: CLOSED"
			port_out="$out4"
			echo "$out4"
			
        	fi
	fi
	echo " "
}
check_remote() {
	header "Check Remote Service"
	read -p "Enter host:" host
	read -p "Enter port:" port
	out=$(curl -s --max-time 5 telnet://"$host":"$port" 2>&1)
	remote_out="$out"
	echo "$out"
	echo " "
}
show_interface() {
	header "Show all interface"
	out=$(ip a 2>&1)
	interface_out="$out"
	echo "$out"
	echo " "
}
exiting() {
	echo "Exiting....."
	sleep 1
	exit 1
}
int_out=""
DNS_out=""
ping_out=""
port_out=""
remote_out=""
interface_out=""


echo "-----NETWORK DEBUG-----[$(date '+%H:%M:%S %d-%m-%Y')]"
echo " "
echo "1.Check Internet Connection"
echo "2.DNS resolution"
echo "3.Ping a domain"
echo "4.Check if a port is open"
echo "5.Check remote service"
echo "6.Show interface"
echo "7.Save previous checks to JSON"
echo "8.Exit"
echo " "
while true;do
	read -p "Enter your choice:" choice
	case $choice in
		1) check_int;;
		2) DNS_resolution;;
		3) ping_domain;;
		4) open_port;;
		5) check_remote;;
		6) show_interface;;
    		7)
    if command -v jq >/dev/null 2>&1; then
               ports_json=$(printf '%s\n' "$port_out" | jq -R -s 'split("\n") | map(select(length>0))')

        mkdir -p "$(dirname "$json_out")"
        jq -n \
          --arg internet "$int_out" \
          --arg dns "$DNS_out" \
          --arg ping "$ping_out" \
          --arg remote "$remote_out" \
          --arg interfaces "$interface_out" \
          --argjson ports "$ports_json" \
          '{
             internet: (if $internet == "" then null else $internet end),
             dns:      (if $dns == "" then null else $dns end),
             ping:     (if $ping == "" then null else $ping end),
             ports:    ($ports),
             remote:   (if $remote == "" then null else $remote end),
             interfaces:(if $interfaces=="" then null else $interfaces end)
           }' | jq '.' > "$json_out"
        if [ ! -s "$json_out" ] || [ "$(jq 'keys | length' "$json_out")" -eq 0 ]; then
            echo "No checks run yet; nothing to save."
            rm -f "$json_out"
        else
            echo "JSON saved to $json_out"
        fi

    else
        json="{\n"
        first=1
        add_field_pretty() {
            key="$1"; val="$2"
            esc=$(printf '%s' "$val" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e ':a;N;$!ba;s/\n/\\n/g')
            if [ $first -eq 0 ]; then
                json+=",\n"
            fi
            json+="  \"${key}\": \"${esc}\""
            first=0
        }

        [ -n "$int_out" ]    && add_field_pretty internet "$int_out"
        [ -n "$DNS_out" ]    && add_field_pretty dns "$DNS_out"
        [ -n "$ping_out" ]   && add_field_pretty ping "$ping_out"


        if [ -n "$port_out" ]; then
            ports_esc=$(printf '%s\n' "$port_out" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e ':a;N;$!ba;s/\n/\\n/g')
            add_field_pretty ports "$ports_esc"
        fi

        [ -n "$remote_out" ] && add_field_pretty remote "$remote_out"
        [ -n "$interface_out" ] && add_field_pretty interfaces "$interface_out"

        if [ $first -eq 1 ]; then
            echo "No checks run yet; nothing to save."
        else
            json+="\n}\n"
            mkdir -p "$(dirname "$json_out")"
            printf '%b' "$json" > "$json_out"
            echo "JSON saved to $json_out"
        fi
    fi
    ;;

		8) exiting;;
		*) echo "Invalid Choice, Enter a valid choice";;
esac
done
