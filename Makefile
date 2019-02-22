# Makefile to compile NetBSD csu for VE

MKPIC=yes
MACHINE_ARCH=ve
ARCHDIR=arch/ve
OBJCOPY=cp
MKSTRIPIDENT=no
TARGET=ve-linux
CLANG=clang
CC=${CLANG} -target $(TARGET) -O

# DEST?=/opt/nec/nosupport/llvm/lib/clang/8.0.0/lib/linux/ve
DEST?=dest

PICFLAGS ?= -fPIC

COMMON_DIR:=	./common
VPATH =		${COMMON_DIR}:${ARCHDIR}

CPPFLAGS+=	-I${NETBSDSRCDIR}/libexec/ld.elf_so -I${COMMON_DIR} -I${ARCHDIR}

OBJS+=		crtbegin.o crtend.o

ifeq (${MKPIC},yes)
OBJS+=		crtbeginS.o
OBJS+=		crtbeginT.o crtendS.o
CFLAGS.crtbegin.c+= -fPIE
endif

realall: ${OBJS}

ifeq ("",$(wildcard ${ARCHDIR}/crtbegin.S))
crtbegin.o: crtbegin.S
	${_MKTARGET_COMPILE}
	${COMPILE.S} ${ARCHDIR}/crtbegin.S -o $@
else
crtbegin.o: crtbegin.c crtbegin.h
	${_MKTARGET_COMPILE}
	${COMPILE.c} ${CFLAGS.crtbegin.c} ${COMMON_DIR}/crtbegin.c -o $@
endif

ifeq ("",$(wildcard ${ARCHDIR}/crtbegin.S))
crtbeginS.o: crtbegin.S
	${_MKTARGET_COMPILE}
	${COMPILE.S} ${PICFLAGS} -DSHARED ${ARCHDIR}/crtbegin.S -o $@
else
crtbeginS.o: crtbegin.c crtbegin.h
	${_MKTARGET_COMPILE}
	${COMPILE.c} ${CFLAGS.crtbeginS.c} ${PICFLAGS} -DSHARED ${COMMON_DIR}/crtbegin.c -o $@
endif

crtend.o: crtend.S
	${_MKTARGET_COMPILE}
	${COMPILE.S} ${ARCHDIR}/crtend.S -o $@

ifneq (${MKPIC},no)
MY_PICFLAGS=	${PICFLAGS}
else
MY_PICFLAGS=
endif

FILES=${OBJS}
FILESDIR=${LIBDIR}
CLEANFILES+=${OBJS}

ifeq (${MKPIC},yes)
crtbeginT.o: crtbegin.o; ln -s $< $@
crtendS.o: crtend.o; ln -s $< $@
endif

install: $(OBJS)
	mkdir -p $(DEST)
	cp crtbegin.o $(DEST)
	cp crtend.o $(DEST)
	cp crtbeginS.o $(DEST)
	rm -f $(DEST)/crtbeginT.o
	ln -s crtbegin.o $(DEST)/crtbeginT.o
	rm -f $(DEST)/crtendS.o
	ln -s crtend.o $(DEST)/crtendS.o

clean: FORCE
	rm -f $(OBJS)

FORCE:
