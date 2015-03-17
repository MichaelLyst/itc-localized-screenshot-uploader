. environment.sh

echo "Ensuring screenshots are flattened and in place..."

for i in `find $ITMSSCREENSHOTSFOLDERRAWNAME -name \*.png -print`; do
	cp -v -f $i "$ITMSSCREENSHOTSFOLDERNAME/"
	cp -v -f $i "$ITMSFOLDERNAME/$ITMSSKU.itmsp/"
done
