@echo off

REM 抽出対象のCSVファイル

set csv_file=example.csv

REM 抽出開始行の指定（0から始まるインデックス）

set start_line=2

REM 抽出する行の間隔

set interval=3

REM ヘッダー行を抽出するかどうか

set include_header=true

REM 出力ファイル名

set output_file=output.csv

REM ヘッダー行の行数

set header_lines=1

REM 抽出完了目安の行数

set milestone_lines=10

REM カウンタ変数

set /a count=0

set /a line_count=0

REM CSVファイルを処理する関数

:process_csv

set file="%csv_file%"

set /a "current_line=0"

(for /f "usebackq tokens=*" %%a in (%file%) do (

    set "line=%%a"

    setlocal enabledelayedexpansion

    if "!current_line!"=="%start_line%" (

        if "%include_header%"=="true" (

            echo !line!

        )

        set /a "line_number=0"

    )

    if "!current_line!" gtr "%start_line%" (

        set /a "line_number+=1"

        set /a "remainder=!line_number! %% %interval%"

        if "!remainder!"=="0" (

            echo !line!

            set /a "count+=1"

            set /a "line_count+=1"

            if !count! equ %milestone_lines% (

                echo --- 現在の行数: !line_count!

                set /a "count=0"

            )

        )

    )

    set /a "current_line+=1"

    endlocal

)) > "%output_file%"

goto :eof

REM CSVファイルを処理する

call :process_csv

