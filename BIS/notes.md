# PTEST1
```
nmap -p- ptest1
Nmap scan report for ptest1 (192.168.122.138)
Host is up (0.00057s latency).
rDNS record for 192.168.122.138: ptest1.local
Not shown: 65532 filtered ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
8080/tcp open  http-proxy
MAC Address: 52:54:00:BD:45:84 (QEMU Virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 153.93 seconds
```

# PTEST2
```
Starting Nmap 5.51 ( http://nmap.org ) at 2016-11-09 13:16 CET
Nmap scan report for ptest2 (192.168.122.192)
Host is up (0.00011s latency).
rDNS record for 192.168.122.192: ptest2.local
Not shown: 65531 closed ports
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
80/tcp   open  http
3306/tcp open  mysql
MAC Address: 52:54:00:1B:9D:C1 (QEMU Virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 6.84 seconds
```

## FTP
https://sweshsec.wordpress.com/2015/07/31/vsftpd-vulnerability-exploitation-with-manual-approach/
zkusil jsem bezne pripojeni na FTP pomoci `ftp ptest2`, zjistil verzi FTP server a googloval, nasel jsem smajlikovy exploit 

# PTEST3
```
Starting Nmap 5.51 ( http://nmap.org ) at 2016-11-09 13:17 CET
Nmap scan report for ptest3 (192.168.122.70)
Host is up (0.00049s latency).
rDNS record for 192.168.122.70: ptest3.local
Not shown: 65533 filtered ports
PORT   STATE SERVICE
22/tcp open  ssh
23/tcp open  telnet
MAC Address: 52:54:00:50:8F:91 (QEMU Virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 149.22 seconds
```

## SSH
pouzil jsem klic smith_rsa a prihlasil jsem se na ptest3

