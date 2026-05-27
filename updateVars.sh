#!/bin/bash

# Variables & Colors Declaration ###############################################
BUILDDIR=_build

IMGGEN=false
if [ "$1" = "imgGen" ]; then IMGGEN=true; fi

MAPLE_COLS="maple R red teal"
ASPEN_COLS="aspen Y yellow blue"
EUCALYPTUS_COLS="eucalyptus T teal mulberry"
JACARANDA_COLS="jacaranda P purple yellow"

source colors.sh

# Color Initialization #########################################################
getCol () {
	# Export the given argument in order to access it from perl as an environment variable
	export LABEL=$1
	# Asign the color to the variable passed as a string in $1
	# the -0777 makes the matching multiline
	colors[$1]=$(perl -0777 -ne 'print $1 if /<linearGradient[^<>]*label="$ENV{LABEL}"[^<>]*>\s+<stop[^<>]*stop-color:(#\w{6})/s' palette.svg)
}

# Iterate over the keys of the array and update the color file
if [ palette.svg -nt colors.sh ]; then
	echo "Updating color register..."
	for c in ${!colors[@]}; do
		getCol $c
		# echo $c ${colors[$c]}
		sed -ri "s/\[$c\]=\"(#[a-fA-F0-9]+)?\"/[$c]=\"${colors[$c]}\"/" colors.sh
	done
	echo -e "Color register updated!\n"
fi

# Assigning to CSS vars of the demo page #######################################
replaceCSS () {
	# The weird 0,/exp/ s//sub/ ensures sed only runs for the first match
	sed -i "0,/\(^\s*--$1: \)\(#\w*\);$/ s//\1$2;/" _public/style.css _public/legacySite.html
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
	sed -i "s/\$BGLAVENDER/${colors[bg${2}Lavender]}/" $tgt
	sed -i "s/\$BGPURPLE/${colors[bg${2}Purple]}/" $tgt
	sed -i "s/\$BGPINK/${colors[bg${2}Pink]}/" $tgt
	sed -i "s/\$BGMULBERRY/${colors[bg${2}Mulberry]}/" $tgt

	sed -i "s/\$VIS/${colors[vis${2}]}/" $tgt
	sed -i "s/\$GRAY0/${colors[gray${2}0]}/" $tgt
	sed -i "s/\$GRAY1/${colors[gray${2}1]}/" $tgt
	sed -i "s/\$GRAY2/${colors[gray${2}2]}/" $tgt

	sed -i "s/\$WHITE/${colors[white]}/" $tgt
	sed -i "s/\$ASH/${colors[ash]}/" $tgt
	sed -i "s/\$COAL/${colors[coal]}/" $tgt
	sed -i "s/\$BLACK/${colors[black]}/" $tgt

	sed -i "s/\$FGHI/${colors[fgHi]}/" $tgt
	sed -i "s/\$REDHI/${colors[redHi]}/" $tgt
	sed -i "s/\$ORANGEHI/${colors[orangeHi]}/" $tgt
	sed -i "s/\$YELLOWHI/${colors[yellowHi]}/" $tgt
	sed -i "s/\$GREENHI/${colors[greenHi]}/" $tgt
	sed -i "s/\$TEALHI/${colors[tealHi]}/" $tgt
	sed -i "s/\$BLUEHI/${colors[blueHi]}/" $tgt
	sed -i "s/\$LAVENDERHI/${colors[lavenderHi]}/" $tgt
	sed -i "s/\$PURPLEHI/${colors[purpleHi]}/" $tgt
	sed -i "s/\$PINKHI/${colors[pinkHi]}/" $tgt
	sed -i "s/\$MULBERRYHI/${colors[mulberryHi]}/" $tgt

	sed -i "s/\$FG/${colors[fg]}/" $tgt
	sed -i "s/\$RED/${colors[red]}/" $tgt
	sed -i "s/\$ORANGE/${colors[orange]}/" $tgt
	sed -i "s/\$YELLOW/${colors[yellow]}/" $tgt
	sed -i "s/\$GREEN/${colors[green]}/" $tgt
	sed -i "s/\$TEAL/${colors[teal]}/" $tgt
	sed -i "s/\$BLUE/${colors[blue]}/" $tgt
	sed -i "s/\$LAVENDER/${colors[lavender]}/" $tgt
	sed -i "s/\$PURPLE/${colors[purple]}/" $tgt
	sed -i "s/\$PINK/${colors[pink]}/" $tgt
	sed -i "s/\$MULBERRY/${colors[mulberry]}/" $tgt
}

# Firefox Themes ###############################################################
buildFirefoxTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant

	local name=${1^}

	local tgtdir=$BUILDDIR/firefox/$name
	local tgt=$tgtdir/manifest.json
	if ! [ -x $tgtdir ] || [ colors.sh -nt $tgt ] || [ firefox/themeSrc.json -nt $tgt ]; then
		echo "Updating Firefox $name theme..."
		mkdir -p $tgtdir
		cp firefox/themeSrc.json $tgt

		replaceColors $name $2 $3 $4

		zip $tgtdir/$name.zip -j $tgtdir/*
		echo -e "Firefox $name theme updated!\n"
	fi
}

buildFirefoxTheme $MAPLE_COLS
buildFirefoxTheme $ASPEN_COLS
buildFirefoxTheme $EUCALYPTUS_COLS
buildFirefoxTheme $JACARANDA_COLS

# Vivaldi Themes ###############################################################
buildVivaldiTheme () {
	# $1 -> The variant name
	# $2 -> The letter to use as variable finder
	# $3 -> The accent color used for the variant
	# $4 -> The inverse accent color used for the variant
	# $5 -> The id for the theme

	local name=${1^}

	local tgtdir=$BUILDDIR/vivaldi/$name
	local tgt=$tgtdir/settings.json
	if ! [ -x $tgtdir ] || [ vivaldi/bgs/$name.jpg -nt $tgt ] || [ colors.sh -nt $tgt ] || [ vivaldi/themeSrc.json -nt $tgt ]; then
		echo "Updating Vivaldi $name theme..."
		mkdir -p $tgtdir
		cp vivaldi/themeSrc.json $tgt

		replaceColors $name $2 $3 $4
		sed -i "s/\$ID/$5/" $tgt

		cp vivaldi/bgs/$name.jpg $tgtdir/background.jpg

		zip $tgtdir/$name.zip -j $tgtdir/*
		echo -e "Vivaldi $name theme updated!\n"
	fi
}

buildVivaldiTheme $MAPLE_COLS "8fc51c5b-7e6e-4a44-abb2-a71c017f89a2"
buildVivaldiTheme $ASPEN_COLS "77105915-183c-452f-a43c-a662a6c41c0f"
buildVivaldiTheme $EUCALYPTUS_COLS "546c5865-a044-44a2-b457-3e142780f412"
buildVivaldiTheme $JACARANDA_COLS "0ff02ff6-8f67-4baf-90f7-0f582ddde81c"

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

buildAlacrittyTheme $MAPLE_COLS
buildAlacrittyTheme $ASPEN_COLS
buildAlacrittyTheme $EUCALYPTUS_COLS
buildAlacrittyTheme $JACARANDA_COLS

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

buildFootTheme $MAPLE_COLS
buildFootTheme $ASPEN_COLS
buildFootTheme $EUCALYPTUS_COLS
buildFootTheme $JACARANDA_COLS

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

buildVSCodeTheme $MAPLE_COLS
buildVSCodeTheme $ASPEN_COLS
buildVSCodeTheme $EUCALYPTUS_COLS
buildVSCodeTheme $JACARANDA_COLS

# Cursor Themes ################################################################
replaceCursorSwatch () {
	# $1 -> The name of the swatch
	# $2 -> The name of the color variable to replace it with
	perl -0777 -pi -e "s/(<linearGradient[^<>]*label=\"$1\">\s*<stop[^<>]*stop-color:)(#\w{6})/\1${colors[$2]}/" $tgt
}

buildCursorTheme () {
	local tgt=breeze6-cursors/src/nevergrove-$1.svg
	if [ colors.sh -nt $tgt ] || [ breeze6-cursors/src/cursors.svg -nt $tgt ]; then
		echo "Updating Breeze 6 cursors $1 theme..."
		cp breeze6-cursors/src/cursors.svg $tgt

		if [ $# -eq 4 ]; then
			replaceCursorSwatch defFill bg${2}1
			replaceCursorSwatch outline fg
			replaceCursorSwatch shadow bg${2}0
			replaceCursorSwatch accent $3
			replaceCursorSwatch invaccent $4
			replaceCursorSwatch infoBg bg${2}Blue
			replaceCursorSwatch copyBg bg${2}Green
			replaceCursorSwatch stopBg bg${2}Red
			replaceCursorSwatch aliasBg bg${2}Teal
			replaceCursorSwatch loadBg bg${2}${3^}
			replaceCursorSwatch expoBg bg${2}3
		else
			replaceCursorSwatch defFill $3
			replaceCursorSwatch outline $2
			replaceCursorSwatch shadow $4
			replaceCursorSwatch accent $5
			replaceCursorSwatch invaccent $6
			replaceCursorSwatch infoBg $3
			replaceCursorSwatch copyBg $3
			replaceCursorSwatch stopBg $3
			replaceCursorSwatch aliasBg $3
			replaceCursorSwatch loadBg $3
			replaceCursorSwatch expoBg coal
		fi
		replaceCursorSwatch blue blue
		replaceCursorSwatch green green
		replaceCursorSwatch red red
		replaceCursorSwatch orange orange
		replaceCursorSwatch teal teal
		replaceCursorSwatch windowServer white

		if $IMGGEN; then
			inkscape $tgt -i expo -j -w 1800 -o _public/imgs/breeze/$1.png > /dev/null
		fi

		echo -e "Breeze 6 cursors $1 theme updated!\n"
	fi
}

buildCursorTheme $MAPLE_COLS
buildCursorTheme $ASPEN_COLS
buildCursorTheme $EUCALYPTUS_COLS
buildCursorTheme $JACARANDA_COLS
buildCursorTheme neutral white black black blue orange