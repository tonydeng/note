#!/bin/bash

# rotation of 90 degrees. Will have to concatenate.
#ffmpeg -i <originalfile> -metadata:s:v:0 rotate=0 -vf "transpose=1" <destinationfile>
#/VLC -I dummy -vvv <originalfile> --sout='#transcode{width=1280,vcodec=mp4v,vb=16384,vfilter={canvas{width=1280,height=1280}:rotate{angle=-90}}}:std{access=file,mux=mp4,dst=<outputfile>}\' vlc://quit

#Allowing blanks in file names
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

#Bit Rate
BR=16384

#where to store fixed files
FIXED_FILES_DIR="fixedFiles"
#rm -rf $FIXED_FILES_DIR
mkdir $FIXED_FILES_DIR

# VLC
VLC_START="/Applications/VLC.app/Contents/MacOS/VLC -I dummy -vvv"
VLC_END="vlc://quit"


#############################################
# Processing of MOV in the wrong orientation
for f in `find . -regex '\./.*\.MOV'`
do
  ROTATION=`exiftool "$f" |grep Rotation|cut -c 35-38`
  SHORT_DIMENSION=`exiftool "$f" |grep "Image Size"|cut -c 39-43|sed 's/x//'`
  BITRATE_INT=`exiftool "$f" |grep "Avg Bitrate"|cut -c 35-38|sed 's/\..*//'`
  echo Short dimension [$SHORT_DIMENSION] $BITRATE_INT

  if test "$ROTATION" != ""; then
    DEST=$(dirname ${f})
    echo "Processing $f with rotation $ROTATION in directory $DEST"
    mkdir -p $FIXED_FILES_DIR/"$DEST"

    if test "$ROTATION" == "0"; then
      cp "$f" "$FIXED_FILES_DIR/$f"

    elif test "$ROTATION" == "180"; then
#      $(eval $VLC_START \"$f\" "--sout="\'"#transcode{vfilter={rotate{angle=-"$ROTATION"}},vcodec=mp4v,vb=$BR}:std{access=file,mux=mp4,dst=\""$FIXED_FILES_DIR/$f"\"}'" $VLC_END )
      $(eval ffmpeg -i \"$f\" -vf hflip,vflip -r 30 -metadata:s:v:0 rotate=0 -b:v "$BITRATE_INT"M -vcodec libx264 -acodec copy \"$FIXED_FILES_DIR/$f\")

    elif test "$ROTATION" == "270"; then
      $(eval ffmpeg -i \"$f\" -vf "scale=$SHORT_DIMENSION:-1,transpose=2,pad=$SHORT_DIMENSION:$SHORT_DIMENSION:\(ow-iw\)/2:0" -r 30 -s "$SHORT_DIMENSION"x"$SHORT_DIMENSION" -metadata:s:v:0 rotate=0 -b:v "$BITRATE_INT"M -vcodec libx264 -acodec copy \"$FIXED_FILES_DIR/$f\" )

    else
#      $(eval $VLC_START \"$f\" "--sout="\'"#transcode{scale=1,width=$SHORT_DIMENSION,vcodec=mp4v,vb=$BR,vfilter={canvas{width=$SHORT_DIMENSION,height=$SHORT_DIMENSION}:rotate{angle=-"$ROTATION"}}}:std{access=file,mux=mp4,dst=\""$FIXED_FILES_DIR/$f"\"}'" $VLC_END )
      echo ffmpeg -i \"$f\" -vf "scale=$SHORT_DIMENSION:-1,transpose=1,pad=$SHORT_DIMENSION:$SHORT_DIMENSION:\(ow-iw\)/2:0" -r 30 -s "$SHORT_DIMENSION"x"$SHORT_DIMENSION" -metadata:s:v:0 rotate=0 -b:v "$BITRATE_INT"M -vcodec libx264 -acodec copy \"$FIXED_FILES_DIR/$f\"
      $(eval ffmpeg -i \"$f\" -vf "scale=$SHORT_DIMENSION:-1,transpose=1,pad=$SHORT_DIMENSION:$SHORT_DIMENSION:\(ow-iw\)/2:0" -r 30 -s "$SHORT_DIMENSION"x"$SHORT_DIMENSION" -metadata:s:v:0 rotate=0 -b:v "$BITRATE_INT"M -vcodec libx264 -acodec copy \"$FIXED_FILES_DIR/$f\" )

    fi

  fi

echo
echo ==================================================================
sleep 1
done

#############################################
# Processing of AVI files for my Panasonic TV
# Use ffmpegX + QuickBatch. Bitrate at 16384. Camera res 640x424
for f in `find . -regex '\./.*\.AVI'`
do
  DEST=$(dirname ${f})
  DEST_FILE=`echo "$f" | sed 's/.AVI/.MOV/'`
  mkdir -p $FIXED_FILES_DIR/"$DEST"
  echo "Processing $f in directory $DEST"
  $(eval ffmpeg -i \"$f\" -r 20 -acodec libvo_aacenc -b:a 128k -vcodec mpeg4 -b:v 8M -flags +aic+mv4 \"$FIXED_FILES_DIR/$DEST_FILE\" )
echo
echo ==================================================================

done

IFS=$SAVEIFS