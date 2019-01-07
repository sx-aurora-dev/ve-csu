CSU for NEC SX-Aurora VE
========================

This repository contains crt{begin,end} replacement files from NetBSD [1]
in order to use them from clang/llvm for VE [2].

[1] https://github.com/NetBSD/src/tree/trunk/lib/csu
[2] https://github.com/SXAuroraTSUBASAResearch/llvm

Please see the documentation provided in NetBSD-README for further
assistance with NetBSD CSU.

Prerequestie
============

 - clang/llvm for VE

How to compile CSU for NEC SX-Aurora VE
=======================================

Compile CSU with make and clang/llvm for VE.

    $ make

Install CSU.

    $ make DEST=... install

LICENSE
=======

All files are under a BSD license, and defined in the header of each file.
