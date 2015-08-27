#!/bin/bash -x
>lista
>modify
>execoes
>search

/opt/zimbra/bin/zmprov gadl | cut -d "@" -f1 >>execoes
echo "galsync" >>execoes
echo "root" >>execoes
echo "spam" >>execoes
echo "admin" >>execoes
echo "postmaster" >>execoes
echo "virus-quarantine" >>execoes

ldapsearch -D "cn=config" -w "jvwPgTi0D" -h 10.1.13.90 -b "dc=copasa,dc=com,dc=br" -s sub dn | grep "uid" >>search

cat search | grep -v -f execoes >>lista

while read line
do
echo $line>>modify
echo "changetype:modify">>modify
echo "replace: zimbraAccountStatus">>modify
echo "zimbraAccountStatus: active">>modify
echo "">>modify
done <lista
ldapmodify -D "cn=config" -w "jvwPgTi0D" -h 10.1.13.90 -f modify
