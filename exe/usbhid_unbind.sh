#!/bin/sh

# this script unbinds the device from UDB HID driver
# Device Number may be obtained by following commands
# $ ls -F /sys/bus/usb/drivers/usbhid/

DEVICE_NUMBER="2-1.6:1.0"

echo -n ${DEVICE_NUMBER} > /sys/bus/usb/drivers/usbhid/unbind
