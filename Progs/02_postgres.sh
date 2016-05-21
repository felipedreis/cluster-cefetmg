#!/bin/bash

mkdir -p /tmp/postgresql
cd /tmp/postgresql

yum install http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-1.noarch.rpm

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/pgdg-94-redhat.repo 

yum --enablerepo="pgdg94" install --downloadonly --downloaddir=./ postgresql-jdbc.noarch postgresql94.x86_64 postgresql94-contrib.x86_64 postgresql94-libs.x86_64 postgresql94-server.x86_64

for pack in $(ls *.rpm);do
	$BASE_DIR/AuxScripts/addPackExtend.sh $pack
done

yum localinstall *.rpm

mv *.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf postgresql