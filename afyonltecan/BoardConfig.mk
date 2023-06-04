# Copyright (C) 2014-2016 The CyanogenMod Project
# Copyright (C) 2017-2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# inherit from common afyonlte
include device/samsung/afyonlte-common/BoardConfigCommon.mk

# Kernel-source (comment all if using prebuilt or twrp build)
#TARGET_KERNEL_CONFIG := kernel3.4.113_afyonltecan4_defconfig

#Nuke later-just to figure the issue with this build
#TARGET_KERNEL_CONFIG := twrp_afyonltecan8_defconfig
#TARGET_KERNEL_VARIANT_CONFIG := msm8926-sec_afyonltecanjj_defconfig
TARGET_KERNEL_CONFIG := kernel3.4.113_afyonltecan3_defconfig

# Init
TARGET_INIT_VENDOR_LIB := libinit_afyonlte

# NFC
# include $(COMMON_PATH)/nfc/pn547/board.mk

# Radio/RIL
include $(COMMON_PATH)/radio/single/board.mk

#########################jjstuffend##########################

# SELinux
include device/samsung/afyonltecan/sepolicy_afyonjj/sepolicy.mk


##########################jjstuffend##########################


# inherit from the proprietary version
-include vendor/samsung/afyonltecan/BoardConfigVendor.mk
