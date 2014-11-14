#!/bin/sh


echo -n 'Preparing files...'
cd ..

rm -f novprog.desktop.in.h
rm -f novprog.desktop.in
cp novprog.desktop novprog.desktop.in
sed -e '/^Name\[/ d' \
	-e '/^GenericName\[/ d' \
	-e '/^Comment\[/ d' \
	-e 's/^Name/_Name/' \
	-e 's/^GenericName/_GenericName/' \
	-e 's/^Comment/_Comment/' \
	-i novprog.desktop.in
intltool-extract --quiet --type=gettext/ini novprog.desktop.in

rm -f novprog.appdata.xml.in.h
rm -f novprog.appdata.xml.in
cp novprog.appdata.xml novprog.appdata.xml.in
sed -e '/p xml:lang/ d' \
	-e '/summary xml:lang/ d' \
	-e '/name xml:lang/ d' \
	-e 's/<p>/<_p>/' \
	-e 's/<\/p>/<\/_p>/' \
	-e 's/<summary>/<_summary>/' \
	-e 's/<\/summary>/<\/_summary>/' \
	-e 's/<name>/<_name>/' \
	-e 's/<\/name>/<\/_name>/' \
	-i novprog.appdata.xml.in
intltool-extract --quiet --type=gettext/xml novprog.appdata.xml.in

cd po
echo ' DONE'


echo -n 'Extracting messages...'
xgettext --from-code=UTF-8 --c++ --keyword=_ --keyword=N_:1 \
	--package-name='NovProg' --copyright-holder='Graeme Gott' \
	--output=description.pot ../*.h
sed 's/CHARSET/UTF-8/' -i description.pot
echo ' DONE'


echo -n 'Updating translations...'
for POFILE in *.po;
do
	echo -n " $POFILE"
	msgmerge --quiet --update --backup=none $POFILE description.pot
done
echo ' DONE'


echo -n 'Merging translations...'
cd ..

intltool-merge --quiet --desktop-style po novprog.desktop.in novprog.desktop
rm -f novprog.desktop.in.h
rm -f novprog.desktop.in

intltool-merge --quiet --xml-style po novprog.appdata.xml.in novprog.appdata.xml
rm -f novprog.appdata.xml.in.h
rm -f novprog.appdata.xml.in

echo ' DONE'
