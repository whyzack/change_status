#!/bin/bash -x
>lista
>modify
>execoes
>search

/opt/zimbra/bin/zmprov gadl | cut -d “@” -f1 >>execoes
echo “galsync” >>execoes
echo “root” >>execoes
echo “spam” >>execoes
echo “admin” >>execoes
echo “postmaster” >>execoes
echo “virus-quarantine” >>execoes

ldapsearch -D “cn=config” -w “SENHA_LDAP” -h IP_SERVIDOR -b “dc=DOMINIO,dc=com,dc=br” -s sub dn | grep “uid” >>search

cat search | grep -v -f execoes >>lista

while read line
do
echo $line>>modify
echo “changetype:modify”>>modify
echo “replace: zimbraAccountStatus”>>modify
echo “zimbraAccountStatus: locked”>>modify
echo “”>>modify
done <lista
ldapmodify -D “cn=config” -w “SENHA_LDAP” -h IP_SERVIDOR -f modify
