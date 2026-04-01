#!/bin/bash

# Variables & Colors Declaration ###############################################
BUILDDIR=build

source colors.sh

# Color Initialization #########################################################
getCol () {
	# Export the given argument in order to access it from perl as an environment variable
	export LABEL=$1
	# Asign the color to the variable passed as a string in $1
	# the -0777 makes the matching multiline
	colors[$1]=$(perl -0777 -ne 'print $1 if /<linearGradient[^<>]*label="$ENV{LABEL}">\s+<stop[^<>]*stop-color:(#\w{6})/s' palette.svg)
}

# Iterate over the keys of the array and update the color file
if [ palette.svg -nt colors.sh ]; then
	echo "Updating color register..."
	for c in ${!colors[@]}; do
		getCol $c
		# echo $c ${colors[$c]}
		sed -ri "s/\[$c\]=\"(#[a-fA-F0-9]+)?\"/[$c]=\"${colors[$c]}\"/" colors.sh
	done
	echo "Color register updated!\n"
fi

# Assigning to CSS vars of the demo page #######################################
replaceCSS () {
	# The weird 0,/exp/ s//sub/ ensures sed only runs for the first match
	sed -i "0,/\(^\s*--$1: \)\(#\w*\);$/ s//\1$2;/" index.html
}

# Iterate over the keys of the array
if [ colors.sh -nt index.html ]; then
	echo "Updating demo page colors..."
	for c in ${!colors[@]}; do
		replaceCSS $c ${colors[$c]}
	done
	echo -e "Demo page colors updated!\n"
fi

# Color substitution auxfunc ###################################################
replaceColors () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant

	sed -i "s/\$VARIANT/$1/" $tgt

	sed -i "s/\$ACCENT/${colors[$3]}/" $tgt
	sed -i "s/\$BGACCENT/${colors[bg$2${3^}]}/" $tgt
	sed -i "s/\$INVACCENT/${colors[$4]}/" $tgt

	sed -i "s/\$BG0/${colors[bg${2}0]}/" $tgt
	sed -i "s/\$BG1/${colors[bg${2}1]}/" $tgt
	sed -i "s/\$BG2/${colors[bg${2}2]}/" $tgt
	sed -i "s/\$BG3/${colors[bg${2}3]}/" $tgt
	sed -i "s/\$BG4/${colors[bg${2}4]}/" $tgt
	sed -i "s/\$BG5/${colors[bg${2}5]}/" $tgt
	sed -i "s/\$BG6/${colors[bg${2}6]}/" $tgt

	sed -i "s/\$FGDIM/${colors[fg${2}Dim]}/" $tgt
	sed -i "s/\$BGRED/${colors[bg${2}Red]}/" $tgt
	sed -i "s/\$BGORANGE/${colors[bg${2}Orange]}/" $tgt
	sed -i "s/\$BGYELLOW/${colors[bg${2}Yellow]}/" $tgt
	sed -i "s/\$BGGREEN/${colors[bg${2}Green]}/" $tgt
	sed -i "s/\$BGTEAL/${colors[bg${2}Teal]}/" $tgt
	sed -i "s/\$BGBLUE/${colors[bg${2}Blue]}/" $tgt
	sed -i "s/\$BGPURPLE/${colors[bg${2}Purple]}/" $tgt
	sed -i "s/\$VIS/${colors[vis${2}]}/" $tgt
	sed -i "s/\$GRAY0/${colors[gray${2}0]}/" $tgt
	sed -i "s/\$GRAY1/${colors[gray${2}1]}/" $tgt
	sed -i "s/\$GRAY2/${colors[gray${2}2]}/" $tgt

	sed -i "s/\$WHITE/${colors[white]}/" $tgt
	sed -i "s/\$BLACK/${colors[black]}/" $tgt
	sed -i "s/\$FG/${colors[fg]}/" $tgt
	sed -i "s/\$RED/${colors[red]}/" $tgt
	sed -i "s/\$ORANGE/${colors[orange]}/" $tgt
	sed -i "s/\$YELLOW/${colors[yellow]}/" $tgt
	sed -i "s/\$GREEN/${colors[green]}/" $tgt
	sed -i "s/\$TEAL/${colors[teal]}/" $tgt
	sed -i "s/\$BLUE/${colors[blue]}/" $tgt
	sed -i "s/\$PURPLE/${colors[purple]}/" $tgt
}

# Firefox Themes ###############################################################
buildFirefoxTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant

	local tgtdir=$BUILDDIR/firefox/$1
	local tgt=$tgtdir/manifest.json
	if ! [ -x $tgtdir ] || [ colors.sh -nt $tgt ] || [ firefox/themeSrc.json -nt $tgt ]; then
		echo "Updating Firefox $1 theme..."
		mkdir -p $tgtdir
		cp firefox/themeSrc.json $tgt

		replaceColors $1 $2 $3 $4

		zip $tgtdir/$1.zip -j $tgtdir/*
		echo -e "Firefox $1 theme updated!\n"
	fi
}

buildFirefoxTheme Maple R red teal
buildFirefoxTheme Aspen Y yellow blue
buildFirefoxTheme Eucalyptus T teal purple
buildFirefoxTheme Jacaranda P purple yellow

# Vivaldi Themes ###############################################################
buildVivaldiTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant
	# $5 -> The id for the theme

	local tgtdir=$BUILDDIR/vivaldi/$1
	local tgt=$tgtdir/settings.json
	if ! [ -x $tgtdir ] || [ vivaldi/bgs/$1.jpg -nt $tgt ] || [ colors.sh -nt $tgt ] || [ vivaldi/themeSrc.json -nt $tgt ]; then
		echo "Updating Vivaldi $1 theme..."
		mkdir -p $tgtdir
		cp vivaldi/themeSrc.json $tgt

		replaceColors $1 $2 $3 $4
		sed -i "s/\$ID/$5/" $tgt

		cp vivaldi/bgs/$1.jpg $tgtdir/background.jpg

		zip $tgtdir/$1.zip -j $tgtdir/*
		echo -e "Vivaldi $1 theme updated!\n"
	fi
}

buildVivaldiTheme Maple R red teal "8fc51c5b-7e6e-4a44-abb2-a71c017f89a2"
buildVivaldiTheme Aspen Y yellow blue "77105915-183c-452f-a43c-a662a6c41c0f"
buildVivaldiTheme Eucalyptus T teal purple "546c5865-a044-44a2-b457-3e142780f412"
buildVivaldiTheme Jacaranda P purple yellow "0ff02ff6-8f67-4baf-90f7-0f582ddde81c"

# Alacritty Themes #############################################################
buildAlacrittyTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant

	local tgtdir=$BUILDDIR/alacritty
	local tgt=$tgtdir/nevergrove_$1.toml
	if ! [ -x $tgtdir ] || [ colors.sh -nt $tgt ] || [ alacritty/themeSrc.toml -nt $tgt ]; then
		echo "Updating Alacritty $1 theme..."
		mkdir -p $tgtdir
		cp alacritty/themeSrc.toml $tgt

		replaceColors $1 $2 $3 $4
		echo -e "Alacritty $1 theme updated!\n"
	fi
}

buildAlacrittyTheme maple R red teal
buildAlacrittyTheme aspen Y yellow blue
buildAlacrittyTheme eucalyptus T teal purple
buildAlacrittyTheme jacaranda P purple yellow

# Foot Themes ##################################################################
buildFootTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant

	local tgtdir=$BUILDDIR/foot
	local tgt=$tgtdir/nevergrove_$1.ini
	if ! [ -x $tgtdir ] || [ colors.sh -nt $tgt ] || [ foot/themeSrc.ini -nt $tgt ]; then
		echo "Updating Foot $1 theme..."
		mkdir -p $tgtdir
		cp foot/themeSrc.ini $tgt

		replaceColors $1 $2 $3 $4

		sed -i "s/#//g" $tgt
		echo -e "Foot $1 theme updated!\n"
	fi
}

buildFootTheme maple R red teal
buildFootTheme aspen Y yellow blue
buildFootTheme eucalyptus T teal purple
buildFootTheme jacaranda P purple yellow

# VSCode Themes ################################################################
buildVSCodeTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant

	local tgt=vscode/nevergrove-vscode/themes/nevergrove-$1-color-theme.json
	if [ colors.sh -nt $tgt ] || [ vscode/themeSrc.jsonc -nt $tgt ]; then
		echo "Updating VSCode $1 theme..."
		cp vscode/themeSrc.jsonc $tgt

		replaceColors $1 $2 $3 $4
		echo -e "VSCode $1 theme updated!\n"
	fi
}

buildVSCodeTheme maple R red teal
buildVSCodeTheme aspen Y yellow blue
buildVSCodeTheme eucalyptus T teal purple
buildVSCodeTheme jacaranda P purple yellow