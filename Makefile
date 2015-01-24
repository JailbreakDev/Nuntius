export ARCHS = armv7 arm64
export TARGET = iphone:clang:8.1
export THEOS_DEVICE_IP = iPhone
include theos/makefiles/common.mk

TWEAK_NAME = Nuntius
Nuntius_FILES = Tweak.xm $(wildcard *.m)
Nuntius_FRAMEWORKS = UIKit CoreGraphics
Nuntius_PRIVATE_FRAMEWORKS = NotificationsUI
Nuntius_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += wanuntius
include $(THEOS_MAKE_PATH)/aggregate.mk
