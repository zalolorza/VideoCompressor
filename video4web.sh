#!/bin/bash

# Based on solution found in: https://gist.github.com/jaydenseric/220c785d6289bcfd7366.

# Set permisions: chmod +x video4web.sh
# Example use: "./video4web.sh master.mp4 filename".


#codecs
h264_codec=true
vp9_codec=true
vp8_codec=false

#bit rates
q[0]=1
q[1]=2
q[2]=3
q[3]=5
q[4]=8
q[5]=10
q[6]=20
q[7]=30


#resolutions
r[0]=640
r[1]=1280
r[2]=1920
r[3]=3840


quality=${q[@]}
resolutions=${r[@]}


for bitrate in $quality ; do


  ##### H264 #####

  if [ "$h264_codec" = true ] ; then
      if [ "$bitrate" -gt 10 ] ; then
        buffsize=5
      elif [ "$bitrate" -gt 3 ] ; then
        buffsize=1
      else
        buffsize=0.5
      fi

      for resolution in $resolutions ; do
      
        if  [[ ("$bitrate" -lt 2 && "$resolution" -ge 1920)   ||  ("$bitrate" -lt 3 && "$resolution" -ge 1920)  ||  ("$bitrate" -lt 8 && "$resolution" -ge 3840) ]]; then
          continue
        fi

        if [[ ("$bitrate" -gt 1 && "$resolution" -le 640)   ||   ("$bitrate" -gt 15 && "$resolution" -le 1280)   ||   ("$bitrate" -gt 12 && "$resolution" -le 1920)   ||  ("$bitrate" -gt 30 && "$resolution" -le 3840) ]]; then
            continue
        fi
          
        
        ffmpeg -i ${1} -c:v libx264 -b:v ${bitrate}M -vf scale=$resolution:-2 -maxrate ${bitrate}M -bufsize ${buffsize}M -pix_fmt yuv420p -tune zerolatency -profile:v baseline -level 3.0 -crf 17 -an -movflags +faststart -threads 0 ${1}_${resolution}_${bitrate}MB.mp4
      
      done
  fi


  ###### WebM ######

  # https://www.webmproject.org/docs/encoder-parameters/

  for resolution in $resolutions ; do

      if  [[ ("$bitrate" -lt 2 && "$resolution" -gt 3840) || ("$bitrate" -gt 30 && "$resolution" -le 1920)  ||  ("$bitrate" -gt 1 && "$resolution" -le 640)  || ("$bitrate" -gt 8 && "$resolution" -le 1280) ]]; then
            continue
      fi
  
      ### VP9 ###

      # https://trac.ffmpeg.org/wiki/Encode/VP9
      # https://developers.google.com/media/vp9/bitrate-modes/
      # https://sites.google.com/a/webmproject.org/wiki/ffmpeg/vp9-encoding-guide

      if [ "$vp9_codec" = true ]; then

        ffmpeg -i "$1" -c:v libvpx-vp9 -b:v ${bitrate}M -maxrate ${bitrate}M -vf scale=$resolution:-2 -crf 15 -an -quality good -speed 1 ${$1}_${resolution}_${bitrate}MB.webm
        
      fi


      ### VP8 ###
      # only for old browser compatibility reasons

      if [ "$vp8_codec" = true ]; then
        ffmpeg -i "$1" -c:v libvpx -b:v ${bitrate}M -maxrate ${bitrate}M -vf scale=$resolution:-2 -crf 15 -an -threads 0 -quality good -speed 1 --cpu-used=1 ${$1}_${resolution}_${bitrate}MB_vp8.webm
      fi

  done

done