#!/bin/bash

# Color Declaration ############################################################
colors=(
	bgR0
	bgR1
	bgR2
	bgR3
	bgR4
	bgR5
	bgR6
	visR
	fgRDim
	bgRRed
	bgROrange
	bgRYellow
	bgRGreen
	bgRTeal
	bgRBlue
	bgRPurple
	grayR0
	grayR1
	grayR2
	bgY0
	bgY1
	bgY2
	bgY3
	bgY4
	bgY5
	bgY6
	visY
	fgYDim
	bgYRed
	bgYOrange
	bgYYellow
	bgYGreen
	bgYTeal
	bgYBlue
	bgYPurple
	grayY0
	grayY1
	grayY2
	bgT0
	bgT1
	bgT2
	bgT3
	bgT4
	bgT5
	bgT6
	visT
	fgTDim
	bgTRed
	bgTOrange
	bgTYellow
	bgTGreen
	bgTTeal
	bgTBlue
	bgTPurple
	grayT0
	grayT1
	grayT2
	bgP0
	bgP1
	bgP2
	bgP3
	bgP4
	bgP5
	bgP6
	visP
	fgPDim
	bgPRed
	bgPOrange
	bgPYellow
	bgPGreen
	bgPTeal
	bgPBlue
	bgPPurple
	grayP0
	grayP1
	grayP2
	white
	black
	fg
	red
	orange
	yellow
	green
	teal
	blue
	purple
)

# Color Initialization #########################################################
getCol () {
	# Export the given argument in order to access it from perl as an environment variable
	export LABEL=$1
	# Asign the color to the variable passed as a string in $1
	# the -0777 makes the matching multiline
	local -n tmp=$1
	tmp=$(perl -0777 -ne 'print $1 if /<linearGradient[^<>]*label="$ENV{LABEL}">\s+<stop[^<>]*stop-color:(#\w{6})/s' palette.svg)
}

for c in ${colors[@]}; do
	getCol $c
done

# Assigning to CSS vars of the demo page #######################################
replaceCSS () {
	# The weird 0,/exp/ s//sub/ ensures sed only runs for the first match
	sed -i "0,/\(^\s*--$1: \)\(#\w*\);$/ s//\1$2;/" index.html
}

for c in ${colors[@]}; do
	declare -n value="$c" # The value of the color stored in the variable of name $c
	replaceCSS $c $value
done