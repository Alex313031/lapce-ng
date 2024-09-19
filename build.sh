#!/bin/bash

# Copyright(c) 2023 Alex313031

YEL='\033[1;33m' # Yellow
CYA='\033[1;96m' # Cyan
RED='\033[1;31m' # Red
GRE='\033[1;32m' # Green
c0='\033[0m' # Reset Text
bold='\033[1m' # Bold Text
underline='\033[4m' # Underline Text

# Error handling
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "${RED}Failed $*"; }

# --help
displayHelp () {
	printf "\n" &&
	printf "${bold}${GRE}Script to build Lapce on Linux.${c0}\n" &&
	printf "${bold}${YEL}Use the --deps flag to install build dependencies.${c0}\n" &&
	printf "${bold}${YEL}Use the --build flag to build Lapce.${c0}\n" &&
	printf "${bold}${YEL}Use the --sse3 flag to build Lapce without AVX.${c0}\n" &&
	printf "${bold}${YEL}Use the --clean flag to run \`cargo clean\`.${c0}\n" &&
	printf "${bold}${YEL}Use the --help flag to show this help.${c0}\n" &&
	printf "\n"
}
case $1 in
	--help) displayHelp; exit 0;;
esac

# Install prerequisites
installDeps () {
	sudo apt-get install build-essential cargo cmake pkg-config libfontconfig-dev libgtk-3-dev git g++
}
case $1 in
	--deps) installDeps; exit 0;;
esac

cleanLapce () {
	printf "\n" &&
	printf "${bold}${YEL} Cleaning artifacts and build directory...${c0}\n" &&
	printf "\n" &&
	
	cargo clean &&
	rm -r -f -v ./bin/lapce &&
	rm -r -f -v ./bin/lapce-proxy &&
	rm -r -f -v ./bin/dev.lapce.lapce.svg &&
	rm -r -f -v ./bin/dev.lapce.lapce.desktop &&
	rm -r -f -v ./bin/dev.lapce.lapce.metainfo.xml &&
	
	printf "\n" &&
	printf "${bold}${GRE} Done.${c0}\n" &&
	printf "\n"
}
case $1 in
	--clean) cleanLapce; exit 0;;
esac

buildLapceAVX () {
# Optimization parameters
export CFLAGS="-DNDEBUG -mavx -maes -O3 -g0 -s" &&
export CXXFLAGS="-DNDEBUG -mavx -maes -O3 -g0 -s" &&
export CPPFLAGS="-DNDEBUG -mavx -maes -O3 -g0 -s" &&
export GLIB_CFLAGS="-DNDEBUG -mavx -maes -O3 -g0 -s" &&
export GLIB_LDFLAGS="-Wl,-O3 -mavx -maes -s" &&
export GTK_LIBS="-DNDEBUG -mavx -maes -O3 -g0 -s" &&
export GTK_CFLAGS="-DNDEBUG -mavx -maes -O3 -g0 -s" &&
export GTK_LDFLAGS="-Wl,-O3 -mavx -maes -s" &&
export LDFLAGS="-Wl,-O3 -mavx -maes -s" &&
export LFLAGS="-Wl,-O3 -mavx -maes -s" &&
export LDLIBS="-Wl,-O3 -mavx -maes -s" &&
export OPT_LEVEL="3" &&
export RUSTFLAGS="-C opt-level=3 -C target-feature=+avx,+aes" &&

printf "\n" &&
printf "${bold}${GRE} Building Lapce for Linux...${c0}\n" &&
printf "\n" &&

cargo build --release -vv &&

printf "\n" &&
mkdir -v -p ./bin &&
cp -r -v ./target/release/lapce ./bin/ &&
cp -r -v ./target/release/lapce-proxy ./bin/ &&
cp -r -v ./extra/images/logo_color.svg ./bin/dev.lapce.lapce.svg &&
cp -r -v ./extra/linux/dev.lapce.lapce.desktop ./bin/ &&
cp -r -v ./extra/linux/dev.lapce.lapce.metainfo.xml ./bin/ &&

printf "\n" &&
printf "${bold}${GRE} Binaries are in ./bin/${c0}\n"
printf "\n"
}
case $1 in
	--build) buildLapceAVX; exit 0;;
esac

buildLapceSSE3 () {
# Optimization parameters
export CFLAGS="-DNDEBUG -msse3 -O3 -g0 -s" &&
export CXXFLAGS="-DNDEBUG -msse3 -O3 -g0 -s" &&
export CPPFLAGS="-DNDEBUG -msse3 -O3 -g0 -s" &&
export GLIB_CFLAGS="-DNDEBUG -msse3 -O3 -g0 -s" &&
export GLIB_LDFLAGS="-Wl,-O3 -msse3 -s" &&
export GTK_LIBS="-DNDEBUG -msse3 -O3 -g0 -s" &&
export GTK_CFLAGS="-DNDEBUG -msse3 -O3 -g0 -s" &&
export GTK_LDFLAGS="-Wl,-O3 -msse3 -s" &&
export LDFLAGS="-Wl,-O3 -msse3 -s" &&
export LFLAGS="-Wl,-O3 -msse3 -s" &&
export LDLIBS="-Wl,-O3 -msse3 -s" &&
export OPT_LEVEL="3" &&
export RUSTFLAGS="-C opt-level=3 -C target-feature=+sse3" &&

printf "\n" &&
printf "${bold}${GRE} Building Lapce for Linux (SSE3 Version)...${c0}\n" &&
printf "\n" &&

cargo build --release -vv &&

printf "\n" &&
mkdir -v -p ./bin &&
cp -r -v ./target/release/lapce ./bin/ &&
cp -r -v ./target/release/lapce-proxy ./bin/ &&
cp -r -v ./extra/images/logo_color.svg ./bin/dev.lapce.lapce.svg &&
cp -r -v ./extra/linux/dev.lapce.lapce.desktop ./bin/ &&
cp -r -v ./extra/linux/dev.lapce.lapce.metainfo.xml ./bin/ &&

printf "\n" &&
printf "${bold}${GRE} Binaries are in ./bin/${c0}\n"
printf "\n"
}
case $1 in
	--sse3) buildLapceSSE3; exit 0;;
esac

printf "\n" &&
printf "${bold}${GRE}Script to build Lapce on Linux.${c0}\n" &&
printf "${bold}${YEL}Use the --deps flag to install build dependencies.${c0}\n" &&
printf "${bold}${YEL}Use the --build flag to build Lapce.${c0}\n" &&
printf "${bold}${YEL}Use the --sse3 flag to build Lapce without AVX.${c0}\n" &&
printf "${bold}${YEL}Use the --clean flag to run \`cargo clean\`.${c0}\n" &&
printf "${bold}${YEL}Use the --help flag to show this help.${c0}\n" &&
printf "\n" &&

tput sgr0 &&
exit 0
