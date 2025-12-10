## **📡 Network Debugging & Reporting Tool**

*A Bash-based network diagnostic assistant with JSON reporting*

This project is a fully interactive network troubleshooting tool written in Bash.  
It combines multiple networking commands into one easy-to-use script for DevOps, Cloud Support, and Linux users who need quick diagnostics.  

The tool can:  
Test connectivity  
Resolve DNS  
Ping hosts  
Scan local ports  
Check remote service availability  
Show network interfaces   
Export all previously executed checks into a clean JSON report  

## **⭐ Features**

✔ Internet Connectivity Check  
Pings reliable hosts to verify internet access.  

✔ DNS Resolution
Uses host to resolve domain names and detect DNS failures.  

✔ Ping Test
Pings any domain and prints round-trip time statistics.  

✔ Local Port Status
Scans open ports using ss and identifies whether a port is OPEN or CLOSED.  

✔ Remote Service Check
Uses curl (with telnet protocol) to test if a remote host is reachable on a given port.  

✔ Show All Network Interfaces
Displays IPv4/IPv6 addresses, MAC addresses, and interface states via ip a.  

✔ JSON Export
Exports ONLY the results of previously-run tests  
Supports:  
jq-based pretty JSON formatting (if installed)  
Custom JSON builder when jq is unavailable  

## **🖥️ Screenshots**
1️⃣ Menu Interface  

Shows all available diagnostic options.  
![Menu](https://github.com/user-attachments/assets/d7a899ff-95b4-4486-a890-5d3a35da6a4e)

2️⃣ Terminal Output

Real-time results from DNS lookup, ping, port scan, remote checks, and interfaces.  
![Terminal](https://github.com/user-attachments/assets/c72996c2-1374-48eb-b184-b77837dc0da1)

3️⃣ Network Logic Functions

Core Bash functions handling every diagnostic option.  
![network logic](https://github.com/user-attachments/assets/9a55823f-e970-498f-8dcd-8b35fa659e3c)

4️⃣ JSON Formatting Logic

Handles pretty JSON output with or without jq.  
![JSON format](https://github.com/user-attachments/assets/beb6f88e-6215-48bc-bb59-da7a2198b2e1)


5️⃣ Final JSON Output

The final machine-readable JSON report.  
![output_json](https://github.com/user-attachments/assets/7ee6b727-8729-47ae-afe5-42b96cbcd7f0)


## **🚀 Usage**  
Make the script executable  
chmod +x network_debug.sh  

Run the tool  
./network_debug.sh  

JSON Output Location  
All exported reports are saved automatically to:  
/home/safi/cloud/network/output.json  

## **📦 Dependencies**

The script uses standard Linux tools:  
ping  
host  
ip  
ss  
curl  
Optional:  
jq → If installed, JSON output becomes “pretty formatted.”  
If jq is missing, the script automatically falls back to a custom JSON builder.  

## **🧠 How It Works (Internal Logic)**

Each diagnostic function stores results in variables:  

int_out=""  
DNS_out=""  
ping_out=""  
port_out=""  
remote_out=""  
interface_out=""  

When the user selects "Save previous checks to JSON", the script:  
Checks which variables are filled  
Converts only those results into JSON  
Uses jq if available  
Otherwise escapes characters manually  
Writes the output to output.json  

This ensures:

✔ NO menu text goes into the JSON  
✔ ONLY relevant user-triggered results are exported  
✔ Output remains structured and clean  

## **📚 Learning Outcomes**
Through this tool, I practiced:  
Bash scripting  
Networking fundamentals  
JSON formatting  
Input validation   
Command output parsing  
Error handling  
Real-world troubleshooting workflow  

## **🔮 Future Enhancements**
Add color-coded output (green/yellow/red)  
Generate HTML or Markdown reports  
Add log rotation for JSON files  
Use systemd timer for automatic periodic checks  
Integrate with cloud storage (AWS S3 uploads)  
Add IPv6 and traceroute checks  

## **🙌 Contributions**

Pull requests, suggestions, and improvements are welcome!

