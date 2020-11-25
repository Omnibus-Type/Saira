#!/bin/sh
set -e


echo "Generating Static fonts"
mkdir -p ../fonts ../fonts/ttf ../fonts/ttf/vf ../fonts/otf
fontmake -g Saira.glyphs -i -o ttf --output-dir ../fonts/ttf/
fontmake -g Saira.glyphs -i -o otf --output-dir ../fonts/otf/
fontmake -g Saira-Italic.glyphs -i -o ttf --output-dir ../fonts/ttf/
fontmake -g Saira-Italic.glyphs -i -o otf --output-dir ../fonts/otf/

echo "Generating VFs"
fontmake -g Saira.glyphs -o variable --output-path ../fonts/ttf/vf/Saira\[wdth,wght\].ttf
fontmake -g Saira-Italic.glyphs -o variable --output-path ../fonts/ttf/vf/Saira-Italic\[wdth,wght\].ttf

rm -rf master_ufo/ instance_ufo/


echo "Post processing"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	./ttfautohint-vf $ttf "$ttf.fix";
	mv "$ttf.fix" $ttf;
	gftools fix-hinting $ttf;
	mv "$ttf.fix" $ttf;


done

echo "Post processing VFs"
vfs=$(ls ../fonts/ttf/vf/*\[wdth,wght\].ttf)
for vf in $vfs
do
	gftools fix-dsig -f $vf;
	./ttfautohint-vf --stem-width-mode nnn $vf "$vf.fix";
	mv "$vf.fix" $vf;
	gftools fix-hinting $vf;
	mv "$vf.fix" $vf;
done


echo "Fixing VF Meta"
gftools fix-vf-meta $vfs;
for vf in $vfs
do
	mv "$vf.fix" $vf;
	ttx -f -x "MVAR" $vf; # Drop MVAR. Table has issue in DW
	rtrip=$(basename -s .ttf $vf)
	new_file=../fonts/ttf/vf/$rtrip.ttx;
	rm $vf;
	ttx $new_file
	rm $new_file
done