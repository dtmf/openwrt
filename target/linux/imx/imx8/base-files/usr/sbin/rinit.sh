#!/bin/sh

echo "Resetting GPS, sx1301, sx126x.."

cd /sys/class/gpio

echo 0 >    gps-reset/value
echo 1 > sx1301-reset/value
echo 1 > sx126x-reset/value

sleep 1

echo 1 >    gps-reset/value
echo 0 > sx1301-reset/value
echo 0 > sx126x-reset/value
