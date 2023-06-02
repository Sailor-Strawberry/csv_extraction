@echo off

REM 抽出対象のCSVファイル
set csv_file=example.csv

REM 抽出開始行の指定（0から始まるインデックス）
set start_line=2

REM 抽出する行の間隔
set interval=3

REM ヘッダー行を抽出するかどうか
set include_header=true

REM CSVファイルを処理する関数
:process_csv
set file="%csv_file%"
for /f "usebackq tokens=*" %%a in (`more +%start_line% %file% ^| findstr /r /n "^"`) do (
    set "line=%%a"
    setlocal enabledelayedexpansion
    set "line=!line:*:=!"
    if "%include_header%"=="true" (
        echo !line!
    ) else (
        set /a "line_number=%%a-%start_line%"
        set /a "remainder=!line_number! %% %interval%"
        if "!remainder!"=="0" (
            echo !line!
        )
    )
    endlocal
)
goto :eof

REM CSVファイルを処理する
call :process_csv
