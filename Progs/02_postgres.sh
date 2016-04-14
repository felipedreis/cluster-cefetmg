#!/bin/bash

mkdir -p /tmp/postgresql
cd /tmp/postgresql

wget http://yum.postgresql.org/9.5/redhat/rhel-6-x86_64/postgresql-jdbc-9.4.1208-1.rhel6.noarch.rpm
wget http://yum.postgresql.org/9.5/redhat/rhel-6-x86_64/postgresql95-9.5.1-1PGDG.rhel6.x86_64.rpm
wget http://yum.postgresql.org/9.5/redhat/rhel-6-x86_64/postgresql95-contrib-9.5.1-1PGDG.rhel6.x86_64.rpm
wget http://yum.postgresql.org/9.5/redhat/rhel-6-x86_64/postgresql95-libs-9.5.1-1PGDG.rhel6.x86_64.rpm
wget http://yum.postgresql.org/9.5/redhat/rhel-6-x86_64/postgresql95-server-9.5.1-1PGDG.rhel6.x86_64.rpm

for pack in $(ls *.rpm);do
	../AuxScripts/addPackExtend.sh $pack
done

rpm -i *.rpm

mv *.rpm $RPM_CONTRIB_DIR

cd ..
rm -rf postgresql