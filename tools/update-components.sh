#/bin/bash

source ./tools/config.sh

CAMERA_REPO_URL="https://github.com/espressif/esp32-camera.git"
CAMERA_REPO_COMMIT="efe711d"
DL_REPO_URL="https://github.com/espressif/esp-dl.git"
DL_REPO_COMMIT="b0f3866"
SR_REPO_URL="https://github.com/espressif/esp-sr.git"
SR_REPO_COMMIT="a779e54"
RMAKER_REPO_URL="https://github.com/espressif/esp-rainmaker.git"
RMAKER_REPO_COMMIT="d8e9345"
LITTLEFS_REPO_URL="https://github.com/joltwallet/esp_littlefs.git"
LITTLEFS_REPO_COMMIT="357d0fd"
TINYUSB_REPO_URL="https://github.com/hathach/tinyusb.git"
TINYUSB_REPO_COMMIT="118823c25"
TFLITE_REPO_URL="https://github.com/espressif/tflite-micro-esp-examples.git"
TFLITE_REPO_COMMIT="209f3cb"

#
# CLONE/UPDATE ESP32-CAMERA
#
echo "Updating ESP32 Camera..."
if [ ! -d "$AR_COMPS/esp32-camera" ]; then
	git clone $CAMERA_REPO_URL "$AR_COMPS/esp32-camera" && \
	git -C "$AR_COMPS/esp32-camera" checkout --recurse-submodules ${CAMERA_REPO_COMMIT} && \
	git -C "$AR_COMPS/esp32-camera" submodule update --init --recursive
else
	git -C "$AR_COMPS/esp32-camera" checkout --recurse-submodules ${CAMERA_REPO_COMMIT} && \
	git -C "$AR_COMPS/esp32-camera" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP-DL
#
echo "Updating ESP-DL..."
if [ ! -d "$AR_COMPS/esp-dl" ]; then
	git clone $DL_REPO_URL "$AR_COMPS/esp-dl"
	git -C "$AR_COMPS/esp-dl" checkout --recurse-submodules ${DL_REPO_COMMIT}
	git -C "$AR_COMPS/esp-dl" submodule update --init --recursive
	#this is a temp measure to fix build issue
	mv "$AR_COMPS/esp-dl/CMakeLists.txt" "$AR_COMPS/esp-dl/CMakeListsOld.txt"
	echo "idf_build_get_property(target IDF_TARGET)" > "$AR_COMPS/esp-dl/CMakeLists.txt"
	echo "if(NOT \${IDF_TARGET} STREQUAL \"esp32c6\" AND NOT \${IDF_TARGET} STREQUAL \"esp32h2\")" >> "$AR_COMPS/esp-dl/CMakeLists.txt"
	cat "$AR_COMPS/esp-dl/CMakeListsOld.txt" >> "$AR_COMPS/esp-dl/CMakeLists.txt"
	echo "endif()" >> "$AR_COMPS/esp-dl/CMakeLists.txt"
	rm -rf "$AR_COMPS/esp-dl/CMakeListsOld.txt"
else
	git -C "$AR_COMPS/esp-dl" checkout --recurse-submodules ${DL_REPO_COMMIT}
	git -C "$AR_COMPS/esp-dl" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi
#this is a temp measure to fix build issue
if [ -f "$AR_COMPS/esp-dl/idf_component.yml" ]; then
	rm -rf "$AR_COMPS/esp-dl/idf_component.yml"
fi

#
# CLONE/UPDATE ESP-SR
#
echo "Updating ESP-SR..."
if [ ! -d "$AR_COMPS/esp-sr" ]; then
	git clone $SR_REPO_URL "$AR_COMPS/esp-sr" && \
	git -C "$AR_COMPS/esp-sr" checkout --recurse-submodules ${SR_REPO_COMMIT} && \
	git -C "$AR_COMPS/esp-sr" submodule update --init --recursive
else
	git -C "$AR_COMPS/esp-sr" checkout --recurse-submodules ${SR_REPO_COMMIT} && \
	git -C "$AR_COMPS/esp-sr" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE ESP-RAINMAKER
#
echo "Updating ESP-RainMaker..."
if [ ! -d "$AR_COMPS/esp-rainmaker" ]; then
    git clone $RMAKER_REPO_URL "$AR_COMPS/esp-rainmaker" && \
	git -C "$AR_COMPS/esp-rainmaker" reset --hard d8e93454f495bd8a414829ec5e86842b373ff555 && \
    git -C "$AR_COMPS/esp-rainmaker" submodule update --init --recursive
else
	git -C "$AR_COMPS/esp-rainmaker" reset --hard d8e93454f495bd8a414829ec5e86842b373ff555 && \
    git -C "$AR_COMPS/esp-rainmaker" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi

#this is a temp measure to fix build issue
if [ -f "$AR_COMPS/esp-rainmaker/components/esp-insights/components/esp_insights/scripts/get_projbuild_gitconfig.py" ] && [ `cat "$AR_COMPS/esp-rainmaker/components/esp-insights/components/esp_insights/scripts/get_projbuild_gitconfig.py" | grep esp32c6 | wc -l` == "0" ]; then
	echo "Overwriting 'get_projbuild_gitconfig.py'"
	cp -f "tools/get_projbuild_gitconfig.py" "$AR_COMPS/esp-rainmaker/components/esp-insights/components/esp_insights/scripts/get_projbuild_gitconfig.py"
fi

#
# CLONE/UPDATE ESP-LITTLEFS
#
echo "Updating ESP-LITTLEFS..."
if [ ! -d "$AR_COMPS/esp_littlefs" ]; then
	git clone $LITTLEFS_REPO_URL "$AR_COMPS/esp_littlefs" && \
	git -C "$AR_COMPS/esp_littlefs" checkout --recurse-submodules ${LITTLEFS_REPO_COMMIT} && \
    git -C "$AR_COMPS/esp_littlefs" submodule update --init --recursive
else
	git -C "$AR_COMPS/esp_littlefs" checkout --recurse-submodules ${LITTLEFS_REPO_COMMIT} && \
    git -C "$AR_COMPS/esp_littlefs" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE TINYUSB
#
echo "Updating TinyUSB..."
if [ ! -d "$AR_COMPS/arduino_tinyusb/tinyusb" ]; then
	git clone $TINYUSB_REPO_URL "$AR_COMPS/arduino_tinyusb/tinyusb" && \
	git -C "$AR_COMPS/arduino_tinyusb/tinyusb" checkout --recurse-submodules ${TINYUSB_REPO_COMMIT} && \
    git -C "$AR_COMPS/arduino_tinyusb/tinyusb" submodule update --init --recursive
else
	git -C "$AR_COMPS/arduino_tinyusb/tinyusb" checkout --recurse-submodules ${TINYUSB_REPO_COMMIT} && \
    git -C "$AR_COMPS/arduino_tinyusb/tinyusb" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi

#
# CLONE/UPDATE TFLITE MICRO
#
echo "Updating TFLite Micro..."
if [ ! -d "$AR_COMPS/tflite-micro" ]; then
	git clone $TFLITE_REPO_URL "$AR_COMPS/tflite-micro"
	git -C "$AR_COMPS/tflite-micro" checkout --recurse-submodules ${TFLITE_REPO_COMMIT} && \
	git -C "$AR_COMPS/tflite-micro" submodule update --init --recursive
else
	git -C "$AR_COMPS/tflite-micro" checkout --recurse-submodules ${TFLITE_REPO_COMMIT} && \
	git -C "$AR_COMPS/tflite-micro" submodule update --init --recursive
fi
if [ $? -ne 0 ]; then exit 1; fi
