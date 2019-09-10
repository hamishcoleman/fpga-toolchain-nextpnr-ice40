# Install dependencies script

base_packages="build-essential pkg-config python3 python3.7-dev libpython3.7-dev"
cross_x64="libboost-dev libboost-filesystem-dev libboost-thread-dev \
           libboost-program-options-dev libboost-python-dev libboost-iostreams-dev \
           libboost-system-dev libboost-chrono-dev libboost-date-time-dev \
           libboost-atomic-dev libboost-regex-dev libpython3.7-dev libeigen3-dev"
for b in $cross_x64; do
    cross_arm64="$cross_arm64 $b:arm64"
    cross_armhf="$cross_armhf $b:armhf"
    criss_i386="$cross_i386 $b:i386"
done

if [ $ARCH == "linux_x86_64" ]; then
    sudo apt-get install -y $base_packages $cross_x64
    gcc --version
    g++ --version
fi

if [ $ARCH == "linux_i686" ]; then
    sudo apt-get install -y $base_packages $cross_i386 \
                            gcc-multilib g++-multilib
    sudo ln -s /usr/include/asm-generic /usr/include/asm
    gcc --version
    g++ --version
fi

if [ $ARCH == "linux_armv7l" ]; then
    sudo apt-get install -y $base_packages $cross_armhf \
                            gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
    arm-linux-gnueabihf-gcc --version
    arm-linux-gnueabihf-g++ --version
fi

# binfmt-support qemu-user-static libeigen3-dev:arm64 qtbase5-dev:arm64 libpython3.5-dev:arm64
if [ $ARCH == "linux_aarch64" ]; then
    sudo apt-get install -y $base_packages $cross_arm64 \
                            gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
    aarch64-linux-gnu-gcc --version
    aarch64-linux-gnu-g++ --version
fi

if [ $ARCH == "windows_x86" ]; then
    echo "Unsupported: $ARCH"
    exit 1
#   sudo apt-get install -y build-essential bison flex libreadline-dev \
#                           gawk tcl-dev libffi-dev git mercurial graphviz \
#                           xdot pkg-config python3.5-dev qt5-default libqt5opengl5-dev $BOOST \
#                           gcc-5-mingw-w64 gc++-5-mingw-w64 wine libeigen3-dev qtbase5-dev libpython3.5-dev zip
#                           #mingw-w64 mingw-w64-tools
#   sudo apt-get autoremove -y
#   ln -s /usr/include/x86_64-linux-gnu/zconf.h /usr/include
#   sudo update-alternatives \
#     --install /usr/bin/i686-w64-mingw32-gcc i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-5 60 \
#     --slave /usr/bin/i686-w64-mingw32-g++ i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-5
#   i686-w64-mingw32-gcc --version
#   i686-w64-mingw32-g++ --version
fi

if [ $ARCH == "windows_amd64" ]; then
    echo "Unsupported: $ARCH"
    exit 1
#   sudo apt-get install -y build-essential bison flex libreadline-dev \
#                           gawk tcl-dev libffi-dev git mercurial graphviz \
#                           xdot pkg-config python3.5-dev qt5-default libqt5opengl5-dev $BOOST \
#                           gcc-5-mingw-w64 gc++-5-mingw-w64 wine libeigen3-dev qtbase5-dev libpython3.5-dev zip
#                           #mingw-w64 mingw-w64-tools
#   sudo apt-get autoremove -y
#   ln -s /usr/include/x86_64-linux-gnu/zconf.h /usr/include
#   sudo update-alternatives \
#     --install /usr/bin/x86_64-w64-mingw32-gcc x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-5 60 \
#     --slave /usr/bin/x86_64-w64-mingw32-g++ x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-5
#   x86_64-w64-mingw32-gcc --version
#   x86_64-w64-mingw32-g++ --version
fi

if [ $ARCH == "darwin" ]; then
  # brew_deps="bison flex gawk git pkg-config gnu-sed wget eigen"
  # brew unlink $brew_deps && brew link --force $brew_deps

  deps="boost-1.67.0-py37_4.tar.bz2 \
        eigen3-3.3.7-0.tar.bz2 \
        py-boost-1.67.0-py37h6440ff4_4.tar.bz2 \
        libboost-1.67.0-hebc422b_4.tar.bz2 \
        python-3.7.4-h359304d_1.tar.bz2"
  for dep in $deps
  do
    mkdir -p /tmp/nextpnr
    pushd /tmp/nextpnr
    echo "Extracting $dep..."
    tar xjf $WORK_DIR/build-data/darwin/$dep
    popd
  done

  # Also extracy Python to our install path, since we'll need it on Darwin
  mkdir -p $PACKAGE_DIR/$NAME
  pushd $PACKAGE_DIR/$NAME
  tar xjf $WORK_DIR/build-data/darwin/python-3.7.4-h359304d_1.tar.bz2
  popd
fi
