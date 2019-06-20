# -- Compile nextpnr-ice40 script

NEXTPNR=nextpnr
COMMIT=29adacf18eaaad7e38ec5b2dd9d1f6ccf9c70c18
GITNEXTPNR=https://github.com/YosysHQ/nextpnr

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $NEXTPNR || git clone $GITNEXTPNR $NEXTPNR
git -C $NEXTPNR pull
git -C $NEXTPNR checkout $COMMIT
git -C $NEXTPNR log -1

# -- Copy the upstream sources into the build directory
rsync -a $NEXTPNR $BUILD_DIR --exclude .git

cd $BUILD_DIR/$NEXTPNR

mkdir icebox
cp -v ../icestorm/icefuzz/*.txt icebox/
cp -v ../icestorm/icebox/*.txt icebox/

# -- Compile it
if [ $ARCH == "darwin" ]; then
  cmake -DARCH=ice40 -DICEBOX_ROOT="./icebox" -DSTATIC_BUILD=ON -DBUILD_HEAP=ON .
  make -j$J CXX="$CXX" LIBS="-lm"
elif [ ${ARCH:0:7} == "windows" ]; then
  cmake -DARCH=ice40 -DICEBOX_ROOT="./icebox" -DBUILD_HEAP=ON -DCMAKE_SYSTEM_NAME=Windows .
  make -j$J CXX="$CXX" LIBS="-static -static-libstdc++ -static-libgcc -lm"
else
  cmake -DARCH=ice40 -DICEBOX_ROOT="./icebox" -DBUILD_HEAP=ON .
  make -j$J CXX="$CXX" LIBS="-static -static-libstdc++ -static-libgcc -lm"
fi || exit 1

# -- Copy the executable to the bin dir
mkdir -p $PACKAGE_DIR/$NAME/bin
cp nextpnr-ice40$EXE $PACKAGE_DIR/$NAME/bin/nextpnr-ice40$EXE