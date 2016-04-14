#!/bin/bash

yum --enablerepo="base, epel" install blas-devel.i686 blas-devel.x86_64 blas.i686 blas.x86_64
yum --enablerepo="base, epel" install atlas.i686 atlas.x86_64
yum --enablerepo="base, epel" install lapack.i686 lapack.x86_64 lapack-devel.x86_64 lapack-devel.i686