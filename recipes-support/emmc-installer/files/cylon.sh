#!/bin/sh

ONE="/sys/class/leds/beaglebone:green:heartbeat"
TWO="/sys/class/leds/beaglebone:green:mmc0"
THREE="/sys/class/leds/beaglebone:green:usr2"
FOUR="/sys/class/leds/beaglebone:green:usr3"

cylon_sequence() {
	echo gpio > ${ONE}/trigger
	echo gpio > ${TWO}/trigger
	echo gpio > ${THREE}/trigger
	echo gpio > ${FOUR}/trigger

	while [ 1 -gt 0 ]; do
		echo 1 > ${ONE}/brightness
		usleep 400000 
		echo 0 > ${ONE}/brightness
		echo 1 > ${TWO}/brightness
		usleep 100000 
		echo 0 > ${TWO}/brightness
		echo 1 > ${THREE}/brightness
		usleep 100000 
		echo 0 > ${THREE}/brightness
		echo 1 > ${FOUR}/brightness
		usleep 400000
		echo 0 > ${FOUR}/brightness
		echo 1 > ${THREE}/brightness
		usleep 100000 
		echo 0 > ${THREE}/brightness
		echo 1 > ${TWO}/brightness
		usleep 100000 
		echo 0 > ${TWO}/brightness
	done
}

restore_leds_and_exit() {
	echo 0 > ${ONE}/brightness
	echo 0 > ${TWO}/brightness
	echo 0 > ${THREE}/brightness
	echo 0 > ${FOUR}/brightness

	echo heartbeat > ${ONE}/trigger
	echo mmc0 > ${TWO}/trigger
	echo none > ${THREE}/trigger
	echo mmc1 > ${FOUR}/trigger

	exit 0
}

trap "restore_leds_and_exit" TERM INT HUP QUIT

cylon_sequence

