@echo off

setlocal enabledelayedexpansion

REM 入力ファイルのパスと名前を指定してください

set /p input_file="分割したいファイル名を入力して下さい（.csvまで）:"

REM 出力ファイルのパスと名前を指定してください
for %%F in ("%input_file%") do set "filename=%%~nF"
set "output_file=%filename%_split.csv"

REM 抽出開始行と抽出間隔を指定してください（1から始まる行番号）

set /p start_row="抽出開始indexを指定して下さい:"

set /p interval="抽出間隔を指定して下さい:"

REM ヘッダー行を抽出するため、ヘッダーの行数を指定してください

set /p header_rows="何行目までをヘッダーとするか入力して下さい:" 

REM ヘッダー行数を加味した抽出開始行を計算します

set /a "adjusted_start_row=start_row + header_rows"

REM 抽出処理を開始します

echo Extracting rows from %input_file%...

echo.

REM ヘッダー行の抽出処理を開始します

set /a "counter=0"

for /f "usebackq delims=" %%a in ("%input_file%") do (

    set /a "counter+=1"

    if !counter! leq %header_rows% (

        echo %%a

    )

    if !counter! equ %header_rows% (

        goto :DataExtraction

    )

) >> "%output_file%"

:DataExtraction

REM データ行の抽出処理を開始します

set /a "counter=0"
set "skip_count=%adjusted_start_row%"
for /f "usebackq tokens=*" %%a in ("%input_file%") do (
    set /a "counter+=1"
    if !counter! geq !skip_count! (
        set /a "remainder=(counter - !adjusted_start_row!) %% %interval%"
        if !remainder! equ 0 (
            echo %%a
        )
    )

) >> "%output_file%"

REM 抽出処理が完了しました

echo.

echo Extraction completed. Extracted rows are saved in %output_file%.

echo.

echo Press any key to exit.

pause > nul
