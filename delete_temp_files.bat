$echo off
IF EXIST "C:\Users\tthomas\AppData\Local\Temp" {
	del /s/q C:\Users\tthomas\AppData\Local\Temp\*
	
	for /d %%d in (C:\Users\tthomas\AppData\Local\Temp*) do (
	rd /q/S "%%~d" && echo "%%~d" >> C:\Users\tthomas\AppData\Local\Temp\output.txt
)
}