# Video Compressor for Web

It compresses a single master video file in different sizes and bitrates for web using [FFMPEG](https://www.ffmpeg.org/). It works in Linux an Mac, not shure about Windows (If it doesn't work in windows, you just need to adjust the arrays).

## How to use it

1) Download and install [FFMPEG](https://www.ffmpeg.org/download.html)
2) Downlad the script `video4web.sh` from this repo.
3) Drop into a folder the script `video4web.sh` and your master video file (let's call it `master.mp4` from now on)
4) Edit `video4web.sh` and set the sizes, bitrates and codecs you want to export your video to:
  ```sh
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
  ````
4) Set permisions: from your terminal run `chmod +x video4web.sh` in the folder where you put the script and the video.
5) Run the script: from your terminal run `./video4web.sh master.mp4 filename` in the folder where you put the script and the video. `filename` is the filename you want to give to the output files (it'll be something like `filename_1280_8MB.mp4`)

Depending on your output settings and your original video, it can take a fair amount of time 
