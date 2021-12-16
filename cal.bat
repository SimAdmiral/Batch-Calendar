@echo off &setlocal
setlocal enabledelayedexpansion

for /f "skip=1 delims=." %%d in ('wmic os get LocalDateTime ^| findstr .') do set "timestamp=%%d"


echo [43;37mMo      Tu      We      Th      Fr      Sa      Su[40;37m

set /a today =%timestamp:~6,2%
IF %today% GTR 7 ( set /a today-=7)
IF %today% GTR 7 ( set /a today-=7)
IF %today% GTR 7 ( set /a today-=7)
IF %today% GTR 7 ( set /a today-=7)
IF %today% GTR 7 ( set /a today-=7)

set /a mouthbefore = %timestamp:~4,2%
set /a yearbefore = %timestamp:~0,4%

rem IF THE MOUNTH IS SOMETHNIG LIKE xx-01-xx
rem THE YEAR MUST BE LAST YEAR
if %mouthbefore% EQU 1 (
	set /a mouthbefore = 12	
	set /a yearbefore-=1 	
) ELSE (
	set /a mouthbefore-=1
)

 
call :DaysOfMonth %yearbefore% %mouthbefore%



set /a up= 0
for /l %%i in (0,1,!today!) do ( 
	set /a outday = %errorlevel%
	set /a mini =  %today%
	set /a mini-=%%i
	set /a outday-=!mini!
	rem -(today-i)
	echo | set /p dummyName= [41;37m!outday![40;37m       
	rem echo | set /p dummyName=!outday!
	set /a up+=1
)

call :DaysOfMonth %timestamp:~0,4% %timestamp:~4,2%


rem echo HERE I WILL CODE THE CALLENDAT PLUS THE DAYS IN MOUNT 

for /l %%i in (1,1,%errorlevel%) do ( 

	set /a pos=%%i 
	set /a pos+=%up%
	set /a pos1=%%i+%up%
	rem echo t !pos!
	rem echo POS !pos1!
	set /a pos%%=7


	
	if !pos! EQU 0 (
		
		if %timestamp:~6,2% EQU %%i (
			echo | set /p dummyName= [43;37m%%i[40;37m       
			echo %%i
		) ELSE ( 
			echo %%i
		)
	) ELSE (
		rem echo | set /p dummyName= %%i 	
		if %timestamp:~6,2% EQU %%i (	
			echo | set /p dummyName= [43;37m%%i[40;37m       
		) ELSE ( 
			echo | set /p dummyName= %%i 	
		)
	)

)





goto :eof

:DaysOfMonth Year Month
setlocal DisableDelayedExpansion
set /a "yy = %~1, mm = 100%~2 %% 100"
:Yep This is not my code-(
set /a "n = 30 + !(((mm & 9) + 6) %% 7) + !(mm ^ 2) * (!(yy %% 4) - !(yy %% 100) + !(yy %% 400) - 2)"
endlocal &exit /b %n%