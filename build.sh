#!/bin/bash
MXE_PATH=/mnt/mxe
MXE_INCLUDE_PATH=$MXE_PATH/usr/i686-w64-mingw32.static/include
MXE_LIB_PATH=$MXE_PATH/usr/i686-w64-mingw32.static/lib

cd src/leveldb
export PATH=/mnt/mxe/usr/bin:$PATH
TARGET_OS=OS_WINDOWS_CROSSCOMPILE make CC=i686-w64-mingw32.static-g++ CXX=i686-w64-mingw32.static-g++ libleveldb.a libmemenv.a
cd ../..

cd src/secp256k1
export PATH=/mnt/mxe/usr/bin:$PATH
sudo ./autogen.sh
sudo ./configure --host=i686-w64-mingw32.static --with-bignum=no --enable-module-recovery use_tests=no cross_compiling=yes --with-field=32bit --with-scalar=32bit --with-asm=x86_64
 sudo TARGET_OS=OS_WINDOWS_CROSSCOMPILE make install CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++ CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++ libsecp256k1.la libsecp256k1.so
sudo make install
cd ../..

i686-w64-mingw32.static-qmake-qt5 \
	BOOST_LIB_SUFFIX=-mt \
	BOOST_THREAD_LIB_SUFFIX=_win32-mt \
	BOOST_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	BOOST_LIB_PATH=$MXE_LIB_PATH \
	OPENSSL_INCLUDE_PATH=$MXE_INCLUDE_PATH/openssl \
	OPENSSL_LIB_PATH=$MXE_LIB_PATH \
	BDB_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	BDB_LIB_PATH=$MXE_LIB_PATH \
	MINIUPNPC_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	MINIUPNPC_LIB_PATH=$MXE_LIB_PATH \
	QMAKE_LRELEASE=/mnt/mxe/usr/i686-w64-mingw32.static/qt5/bin/lrelease qt.pro

make -f Makefile.Release
