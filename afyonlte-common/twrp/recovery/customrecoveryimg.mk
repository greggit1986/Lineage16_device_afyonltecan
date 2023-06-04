LZMA_BIN := /usr/bin/lzma

CL_GRN="\033[32m"
PRT_INS := $(CL_GRN)
PRT_IMG := $(CL_GRN)
CL_RST="\033[0m"

#JJEDITSTART

ifeq ($(strip $(BOARD_KERNEL_SEPARATED_DT)),true)
ifneq ($(strip $(BOARD_KERNEL_PREBUILT_DT)),true)
ifeq ($(strip $(BUILD_TINY_ANDROID)),true)
include system/tools/dtbtool/Android.mk
endif

ifeq ($(strip $(TARGET_CUSTOM_DTBTOOL)),)
DTBTOOL_NAME := dtbToolLineage
else
DTBTOOL_NAME := $(TARGET_CUSTOM_DTBTOOL)
endif

DTBTOOL := $(HOST_OUT_EXECUTABLES)/$(DTBTOOL_NAME)$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

ifeq ($(strip $(TARGET_CUSTOM_DTBTOOL)),)
# dtbToolCM will search subdirectories
possible_dtb_dirs = $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/
else
# Most specific paths must come first in possible_dtb_dirs
possible_dtb_dirs = $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/exynos/ $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/ $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/
endif

define build-dtimage-target
    $(call pretty,"Target dt image: $@")
    $(hide) for dir in $(possible_dtb_dirs); do \
        if [ -d "$$dir" ]; then \
            dtb_dir="$$dir"; \
            break; \
        fi; \
    done; \
    $(DTBTOOL) $(BOARD_DTBTOOL_ARGS) -o $@ -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ "$$dtb_dir";
    $(hide) chmod a+r $@
endef

$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(INSTALLED_KERNEL_TARGET)
	$(build-dtimage-target)
	@echo "Made DT image: $@"

.PHONY: dtimage
dtimage: $(INSTALLED_DTIMAGE_TARGET)

endif
endif

#JJEDITEND


$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
        $(recovery_uncompressed_ramdisk) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo -e ${PRT_IMG}"----- Compressing recovery ramdisk with lzma ------"${CL_RST}
	if [ -e $(recovery_uncompressed_ramdisk).lzma ] ;\
	then \
		rm $(recovery_uncompressed_ramdisk).lzma ; \
	fi;
	$(LZMA_BIN) $(recovery_uncompressed_ramdisk)
	$(hide) cp $(recovery_uncompressed_ramdisk).lzma $(recovery_ramdisk)
	@echo -e ${PRT_IMG}"----- Making recovery image ------"${CL_RST}
	$(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${PRT_IMG}"----- Made recovery image: $@ --------"${CL_RST}


$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
