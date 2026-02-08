SRC_FILE = bin2dec

SRC_DIR = ./src
BUILD_DIR = ./build
SRC_IN = ${SRC_DIR}/${SRC_FILE}.s
BIN_OUT = ${BUILD_DIR}/${SRC_FILE}.out
LST_OUT = ${BUILD_DIR}/${SRC_FILE}.lst
SNA_OUT = ${BUILD_DIR}/${SRC_FILE}.sna
BUILD_CC=vasm

.PHONY: help
help:
	@echo "Usage":
	@sed -n 's/^##//p' ${MAKEFILE_LIST} |  sed -e 's/^/ /'

## build: Build the application
.PHONY: build
build:
	@mkdir -p ${BUILD_DIR} && chown 1000:1000 ${BUILD_DIR}
	${BUILD_CC} -Fbin -L ${LST_OUT} -dotdir ${SRC_IN} -o ${BIN_OUT}
	hexdump -C ${BIN_OUT}

# program: send program to minicontroller
.PHONY: program
program:
	@minipro -p AT28C256 -w ${BIN_OUT}

## clean: Clean-up the build binaries
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf ${BUILD_DIR}
