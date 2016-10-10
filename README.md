# docker-samba

basic Alpine image with samba dc installed designed to be used for Samba Active Directory Services

https://wiki.samba.org/index.php/Setup_a_Samba_Active_Directory_Domain_Controller

```
docker run --rm -it \
  -v $LOCAL/samba/etc/:/etc/samba/ \
  -v $LOCAL/samba/lib/:/var/lib/samba/ \
  -h DC1.EXAMPLE.COM \
  rungeict/samba samba-tool domain provision --use-rfc2307 --realm=EXAMPLE.COM --domain=EXAMPLE --server-role=dc --adminpass=EXAMPLE
  
  
docker run -t -d \
  -v $LOCAL/samba/etc/:/etc/samba/ \
  -v $LOCAL/samba/lib/:/var/lib/samba/ \
  -h DC1.EXAMPLE.COM \
  -p 139:139 \
  -p 445:445 \
  --name samba-ad \
  rungeict/samba
```