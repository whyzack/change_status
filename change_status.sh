#!/bin/bash -x
#By Isaac Souza whyzack@gmail.com

#Zera os arquivos que serao usados
#>lista
>modify
>execoes
>search

#Cria lista de execoes
/opt/zimbra/bin/zmprov gadl | cut -d "@" -f1 >>execoes
ldapsearch -D "cn=config" -w SENHA_LDAP -h IP_SERVIDOR -b "dc=DOMINIO,dc=com,dc=br" -s sub zimbraMailAlias | grep -i zimbramailalias | cut -d " " -f2 | grep @bonanza |cut -d "@" -f1>>execoes
echo "virus-quarantine.32udv9bqt4" >>execoes
echo "virus-quarantine.5vz91o0e" >>execoes
echo "galsync.scesjk2ce" >>execoes
echo "galsync.qtyrrw0p" >>execoes
echo "spam.l993yml_sh" >>execoes
echo "spam.0bwsfr7oz" >>execoes
echo "ham.fos6c55hb" >>execoes

#Preenche todos os usuarios
ldapsearch -D "cn=config" -w SENHA_LDAP -h IP_SERVIDOR -b "dc=DOMINIO,dc=com,dc=br" -s sub dn | grep "uid"|grep -v zimbraDataSourceName >>search

#cat search | grep -v -f execoes >>lista

#Retira as execoes
while read linha
do
sed -i /$linha,ou/d search
done<execoes

#Preenche arquivo de alteracoes no Ldap
while read line
do
echo $line>>modify
echo "changetype:modify">>modify
echo "replace: zimbraAccountStatus">>modify
echo "zimbraAccountStatus: active">>modify
echo "">>modify
done <search

#Executa as alteracoes no Ldap
ldapmodify -D "cn=config" -w SENHA_LDAP -h IP_SERVIDOR -f modify
