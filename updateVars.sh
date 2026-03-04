#!/bin/bash

getCol () {
	# Export the given argument in order to access it from perl as an environment variable
	export LABEL=$1
	# Asign the color to the variable passed as a string in $1
	local -n tmp=$1
	tmp=$(perl -0777 -ne 'print $1 if /<.*fill:(#.{6}).*label="$ENV{LABEL}".*>/s' palette.svg)
}

# Assign the color from the inkscape svg into variables with the passed name:

getCol bgR0
getCol bgR1
getCol bgR2
getCol bgR3
getCol bgR4
getCol bgR5
getCol bgR6
getCol grayR0
getCol grayR1
getCol grayR2

getCol bgY0
getCol bgY1
getCol bgY2
getCol bgY3
getCol bgY4
getCol bgY5
getCol bgY6
getCol grayY0
getCol grayY1
getCol grayY2

getCol bgT0
getCol bgT1
getCol bgT2
getCol bgT3
getCol bgT4
getCol bgT5
getCol bgT6
getCol grayT0
getCol grayT1
getCol grayT2

getCol bgP0
getCol bgP1
getCol bgP2
getCol bgP3
getCol bgP4
getCol bgP5
getCol bgP6
getCol grayP0
getCol grayP1
getCol grayP2

getCol fg
getCol red
getCol orange
getCol yellow
getCol green
getCol teal
getCol blue
getCol purple
getCol visual
getCol bgRed
getCol bgOrange
getCol bgYellow
getCol bgGreen
getCol bgTeal
getCol bgBlue
getCol bgPurple



