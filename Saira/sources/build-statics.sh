#!/bin/sh
set -e
fontName="Saira"
fontName_it="Saira-Italic"
axes="wdth,wght"

##########################################

echo ".
GENERATING TTF
."
TT_DIR=../fonts/Saira/ttf
rm -rf $TT_DIR
mkdir -p $TT_DIR

fontmake -g $fontName.glyphs -i -o ttf --output-dir $TT_DIR
fontmake -g $fontName_it.glyphs -i -o ttf --output-dir $TT_DIR

# echo ".
# GENERATING OTF
# ."
# OT_DIR=../Saira/otf
# rm -rf $OT_DIR
# mkdir -p $OT_DIR

# fontmake -g $fontName.glyphs -i -o otf --output-dir $OT_DIR
# fontmake -g $fontName_it.glyphs -i -o otf --output-dir $OT_DIR

rm -rf instance_ufo/ master_ufo/

##########################################

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls $TT_DIR/*.ttf)
for font in $ttfs
do
	gftools fix-dsig --autofix $font
	python -m ttfautohint $font $font.fix
	mv $font.fix $font
	gftools fix-hinting $font
	mv $font.fix $font
done

# echo ".
# POST-PROCESSING OTF
# ."
# otfs=$(ls $OT_DIR/*.otf)
# for font in $otfs
# do
# 	gftools fix-dsig --autofix $font
# 	gftools fix-weightclass $fonts
# 	[ -f $font.fix ] && mv $font.fix $font
# done


##########################################

echo ".
MOVING TTF
."

rm -rf ../fonts/SairaCondensed/ttf ../fonts/SairaExpanded/ttf ../fonts/SairaExtraCondensed/ttf ../fonts/SairaSemiCondensed/ttf ../fonts/SairaSemiExpanded/ttf ../fonts/SairaUltraCondensed/ttf

mkdir ../fonts/SairaCondensed/ttf ../fonts/SairaExpanded/ttf ../fonts/SairaExtraCondensed/ttf ../fonts/SairaSemiCondensed/ttf ../fonts/SairaSemiExpanded/ttf ../fonts/SairaUltraCondensed/ttf

mv $TT_DIR/SairaCondensed*.ttf ../fonts/SairaCondensed/ttf
mv $TT_DIR/SairaExpanded*.ttf ../fonts/SairaExpanded/ttf
mv $TT_DIR/SairaExtraCondensed*.ttf ../fonts/SairaExtraCondensed/ttf
mv $TT_DIR/SairaSemiCondensed*.ttf ../fonts/SairaSemiCondensed/ttf
mv $TT_DIR/SairaSemiExpanded*.ttf ../fonts/SairaSemiExpanded/ttf
mv $TT_DIR/SairaUltraCondensed*.ttf ../fonts/SairaUltraCondensed/ttf

# echo ".
# MOVING OTF
# ."

#rm -rf ../fonts/SairaCondensed/otf ../fonts/SairaExpanded/otf ../fonts/SairaExtraCondensed/otf ../fonts/SairaSemiCondensed/otf ../fonts/SairaSemiExpanded/otf ../fonts/SairaUltraCondensed/otf

#mkdir ../fonts/SairaCondensed/otf ../fonts/SairaExpanded/otf ../fonts/SairaExtraCondensed/otf ../fonts/SairaSemiCondensed/otf ../fonts/SairaSemiExpanded/otf ../fonts/SairaUltraCondensed/otf

# mv $TT_DIR/SairaCondensed*.otf ../fonts/SairaCondensed/otf
# mv $TT_DIR/SairaExpanded*.otf ../fonts/SairaExpanded/otf
# mv $TT_DIR/SairaExtraCondensed*.otf ../fonts/SairaExtraCondensed/otf
# mv $TT_DIR/SairaSemiCondensed*.otf ../fonts/SairaSemiCondensed/otf
# mv $TT_DIR/SairaSemiExpanded*.otf ../fonts/SairaSemiExpanded/otf
# mv $TT_DIR/SairaUltraCondensed*.otf ../fonts/SairaUltraCondensed/otf

##########################################


echo ".
COMPLETE!
."
