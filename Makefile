PACKAGE_JSON_STM=package_koozyt_qboard_index.json
ARCHIVE_STM=qboard_stm32.tar.bz2
UPLOADER_STM=../koozyt_uploader_stm/build/package_qboard_uploader.json

all: build/${PACKAGE_JSON_STM}

build/${ARCHIVE_STM}:
	tar cjf build/${ARCHIVE_STM} stm32

build/stm-shsum: build/${ARCHIVE_STM}
	cd build && shasum -a 256 ${ARCHIVE_STM} | cut -d' ' -f1 > stm-shsum

build/stm-size: build/${ARCHIVE_STM}
	cd build && ls -l ${ARCHIVE_STM} | cut -d' ' -f5 > stm-size

build/${PACKAGE_JSON_STM}: packaging/${PACKAGE_JSON_STM} build/stm-shsum build/stm-size ${UPLOADER_STM}
	sed -e "s/%%CHECKSUM%%/`cat build/stm-shsum`/" -e "s/%%SIZE%%/`cat build/stm-size`/" < packaging/${PACKAGE_JSON_STM} | awk -v "f1=$$(< ${UPLOADER_STM})" '{gsub("%%TOOLS%%", f1); print}' | json_pp > build/${PACKAGE_JSON_STM}
