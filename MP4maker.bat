@ECHO OFF
TITLE MP4maker
CD /D %~dp1
REM CHECK AUDIO
>_tmp (mediainfo --Output="Audio;%%Format%%" "%~nx1")
SET /P AUDIO=<_tmp
DEL _tmp
IF %AUDIO%==AAC SET "AB=-c:a copy" & GOTO CHECK-VIDEO
>_tmp (mediainfo --Output="Audio;%%BitRate%%" "%~nx1")
SET /P ABBB=<_tmp
DEL _tmp
SET /A ABB=%ABBB%/1000
SET "AB=-b:a %ABB%k"
IF %ABB% GEQ 320 SET "AB=-b:a 320k"
: CHECK-VIDEO
>_tmp (mediainfo --Inform="Video;%%ScanType%%" "%~nx1")
SET /P VIDEO=<_tmp
DEL _tmp
IF %VIDEO%==Interlaced GOTO INTERLACED
: TRANSCODE
ffpb -i "%~nx1" -vcodec h264 -preset veryslow -crf 12 -tune film -acodec aac %AB% -scodec mov_text "%~n1.mp4"
GOTO FINISH
: INTERLACED
ffpb -i "%~nx1" -vcodec h264 -preset veryslow -crf 12 -tune film -filter:v bwdif=mode=send_field:parity=auto:deint=all -acodec aac %AB% -scodec mov_text "%~n1.mp4"
: FINISH
PAUSE
EXIT
