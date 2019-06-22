#v1.1
#below three lines need to be changed in each capture.
APP_NAME="flo"
CAPTURE_FOLDER_PATH="/sdcard/screencap/raw"
PULL_PATH="/home/kimberly/HDD/Data/test/$APP_NAME"

RAW_FILE_PATH="$PULL_PATH/raw"
PNG_FILE_PATH="$PULL_PATH/png"

#-p means to make a directory if it does not exits.
adb shell mkdir "-p" $CAPTURE_FOLDER_PATH

CAPTURE_INDEX=0
CAPTURE_STOP=true

while $CAPTURE_STOP
do

CAPTURE_INDEX=$((CAPTURE_INDEX+1))
CAPTURE_FILE_NAME=$(printf "%03d" "$CAPTURE_INDEX")
adb shell "screencap $CAPTURE_FOLDER_PATH/$CAPTURE_FILE_NAME.raw"

#do while loop in a background to be able to get input.
done &

echo "Hit Enter to finish the capture."
#read input and finish the screencap process.
read
kill $!

#wait until the loop process ends before the pull.
sleep 1

echo "Pull starts"
mkdir "-p" $PULL_PATH
adb pull $CAPTURE_FOLDER_PATH $PULL_PATH
adb shell rm $CAPTURE_FOLDER_PATH -r

CONVERT_INDEX=0

FILE_NUMBER=$(ls -l $RAW_FILE_PATH | egrep -c '^-')

echo "Conversion starts"
mkdir "-p" $PNG_FILE_PATH
while (($CONVERT_INDEX < $FILE_NUMBER))
do

CONVERT_INDEX=$((CONVERT_INDEX+1))
CONVERT_FILE_NAME=$(printf "%03d" "$CONVERT_INDEX")
FILENAME="$RAW_FILE_PATH/$CONVERT_FILE_NAME"
OUTPUT_FILENAME="$PNG_FILE_PATH/$CONVERT_FILE_NAME"

# remove the header
tail -c +13 $FILENAME.raw > $FILENAME.rgba

convert -size 1080x1920 -depth 8 $FILENAME.rgba $OUTPUT_FILENAME.png

rm $FILENAME.rgba

done

echo "Capture Finished!"


