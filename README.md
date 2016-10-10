# docker-samba

A basic Alpine image with samba dc installed designed to be used for Samba Active Directory Services

[https://wiki.samba.org/index.php/Setup_a_Samba_Active_Directory_Domain_Controller]

see the following for commands on how to use. this requires a local mapping or a shared container volume.
```
# automatic provisioning
docker run --rm -it \
  -v $LOCAL/samba/etc/:/etc/samba/ \
  -v $LOCAL/samba/lib/:/var/lib/samba/ \
  -h DC1.EXAMPLE.COM \
  rungeict/samba-dc samba-tool domain provision --use-rfc2307 --realm=EXAMPLE.COM --domain=EXAMPLE --server-role=dc --adminpass=EXAMPLE
  
# i have not got the following to work so far. i have had to revert to --net=host
# and set the hostname on the main machine. probably something to do with interface binding and dns

# dont forget -t. samba launches in interactive mode and requires a terminal
docker run -t -d \
  -v $LOCAL/samba/etc/:/etc/samba/ \
  -v $LOCAL/samba/lib/:/var/lib/samba/ \
  -h DC1.EXAMPLE.COM \
  --dns-search=EXAMPLE.COM \
  -p 53:53 -p 88:88 -p 135:135 -p 138:138 \
  -p 389:389 -p 464:464 -p 636:636 -p 1024:1024 \
  -p 3268:3268 -p 3269:3269 \
  -p 53:53/udp -p 88:88/udp -p 137:137/udp \
  -p 138:138/udp -p 389:389/udp -p 464:464/udp \
  --name samba-ad \
  rungeict/samba-dc

# if you run firewalld
firewall-cmd --zone=public --permanent --add-port=53/tcp
firewall-cmd --zone=public --permanent --add-port=53/udp
firewall-cmd --zone=public --permanent --add-port=88/tcp
firewall-cmd --zone=public --permanent --add-port=88/udp
firewall-cmd --zone=public --permanent --add-port=135/tcp
firewall-cmd --zone=public --permanent --add-port=137/udp
firewall-cmd --zone=public --permanent --add-port=138/udp
firewall-cmd --zone=public --permanent --add-port=139/tcp
firewall-cmd --zone=public --permanent --add-port=389/tcp
firewall-cmd --zone=public --permanent --add-port=389/udp
firewall-cmd --zone=public --permanent --add-port=445/tcp
firewall-cmd --zone=public --permanent --add-port=464/tcp
firewall-cmd --zone=public --permanent --add-port=464/udp
firewall-cmd --zone=public --permanent --add-port=636/tcp
firewall-cmd --zone=public --permanent --add-port=1024-5000/tcp

firewall-cmd --reload && systemctl restart docker

# testing if samba works
docker exec -it samba-ad  smbclient -L localhost -U%
docker exec -it samba-ad smbclient //localhost/netlogon -UAdministrator -c 'ls'

# this wont work, bind-utils are not installed
docker exec -it samba-ad host -t SRV _ldap._tcp.example.com.

```

## TODO
- figure out why dns does not respond when behind docker bridge
- install bind-utils