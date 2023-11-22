@ECHO OFF
TITLE MP4maker
CD /D %~dp1
REM CHECK GPU
SET "GPU1=-i"
SET "GPU2=-vcodec h264 -preset veryslow -crf 12 -tune film"
>_tmp (wmic PATH Win32_VideoController GET AdapterCompatibility)
FIND /I "NVIDIA" < _tmp > NUL
IF %errorlevel%==0 SET "GPU1=-hwaccel cuda -hwaccel_output_format cuda -i" & SET "GPU2=-vcodec h264_nvenc -crf 12"
DEL _tmp
REM CHECK AUDIO
SET AUDIO=X
>_tmp (mediainfo --Output="Audio;%%Format%%" "%~nx1")
SET /P AUDIO=<_tmp
DEL _tmp
IF %AUDIO%==AAC SET "AB=-c:a copy" & GOTO CHECK-VIDEO
IF %AUDIO%==FLAC SET "AB=-c:a copy" & GOTO CHECK-VIDEO
>_tmp (mediainfo --Output="Audio;%%BitRate%%" "%~nx1")
SET ABBB=X
SET /P ABBB=<_tmp
DEL _tmp
SET /A ABB=%ABBB%/1000
SET "AB=-b:a %ABB%k"
IF %ABB% GEQ 320 SET "AB=-b:a 320k"
: CHECK-VIDEO
SET VIDEO=X
>_tmp (mediainfo --Inform="Video;%%ScanType%%" "%~nx1")
SET /P VIDEO=<_tmp
DEL _tmp
IF %VIDEO%==Interlaced GOTO INTERLACED
: TRANSCODE
ffmpeg-bar %GPU1% "%~nx1" %GPU2% -acodec aac %AB% -scodec mov_text "%~n1.mp4"
GOTO FINISH
: INTERLACED
ffmpeg-bar %GPU1% "%~nx1" %GPU2% -filter:v bwdif=mode=send_field:parity=auto:deint=all -acodec aac %AB% -scodec mov_text "%~n1.mp4"
: FINISH
PAUSE
EXIT
