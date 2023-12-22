@ECHO OFF
TITLE MP4maker

CD /D %~dp1

SET "GPU=-vcodec libx265"

REM ---GPU CHECKING---
REM >_tmp (wmic PATH Win32_VideoController GET AdapterCompatibility)
REM FIND /I "NVIDIA" < _tmp > NUL
REM IF %errorlevel%==0 SET "GPU=-vcodec h264_nvenc -preset:v p7 -tune:v grain -rc:v vbr -cq:v 12 -b:v 0 -profile:v high"
REM DEL _tmp

REM ---AUDIO CHECKING---
SET AUDIO=X
>_tmp (mediainfo --Output="Audio;%%Format%%" "%~nx1")
SET /P AUDIO=<_tmp
DEL _tmp

REM ---VIDEO BITRATE CHECKING---
>_tmp (mediainfo --Output="Video;%%BitRate%%" "%~nx1")
SET VBA=1
SET /P VBA=<_tmp
DEL _tmp
SET /A VBB=%VBA%/1000
SET "VB=-b:v %VBB%k"
IF %VBB%==0 SET "VB=-crf 18"

REM --- AUDIO CHECKING---
IF %AUDIO%==AAC SET "AB=-c:a copy" & GOTO CHECK-VIDEO
IF %AUDIO%==FLAC SET "AB=-c:a copy" & GOTO CHECK-VIDEO

REM ---AUDIO BITRATE CHECKING---
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
ffmpeg-bar -i "%~nx1" %GPU% %VB% -acodec aac %AB% -scodec mov_text "%~n1.mp4"
GOTO FINISH
: INTERLACED
ffmpeg-bar -i "%~nx1" %GPU% %VB% -filter:v bwdif=mode=send_field:parity=auto:deint=all -acodec aac %AB% -scodec mov_text "%~n1.mp4"
: FINISH
PAUSE
EXIT
