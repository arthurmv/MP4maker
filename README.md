# MP4maker
A Windows ffmpeg script aiming to get balanced best quality transcoding to standard mp4 video file with ease.

![MP4maker screenshot](https://raw.githubusercontent.com/arthurmv/MP4maker/main/img/screenshot.png "MP4maker screenshot")
## Requirements
* [ffmpeg](https://ffmpeg.org/download.html#build-windows) in PATH
* [MediaInfo CLI](https://mediaarea.net/en/MediaInfo/Download/Windows) in PATH
* [Node.JS](https://nodejs.org/en/download) and [ffmpeg-progressbar-cli](https://github.com/sidneys/ffmpeg-progressbar-cli) (`npm install --global ffmpeg-progressbar-cli`).

## Usage
Just drag the video file on and that's it. It detects interlaced video and process using [bwdif](https://ffmpeg.org/ffmpeg-filters.html#bwdif-1), making some fast motions in certain videos and leaving progressive video as is.\
You can create a shorcut on your desktop or [create an option in Windows menu](https://www.sordum.org/7615/easy-context-menu-v1-6/) in order to access everywhere. ![Menu screenshot](https://raw.githubusercontent.com/arthurmv/MP4maker/main/img/menu.png "Menu screenshot")
