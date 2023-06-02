@echo off

REM 抽出対象のCSVファイル

set csv_file=example.csv

REM 抽出開始行の指定（1から始まるインデックス）

set start_line=10

REM 抽出する行の間隔

set interval=20

REM 出力ファイル名

set output_file=output.csv

REM 抽出完了目安の行数

set milestone_lines=10

REM カウンタ変数

set /a count=0

set /a line_count=0

REM プログレス表示関数

:show_progress

echo 処理中… %line_count%行抽出完了

goto :eof

REM CSVファイルを処理する関数

:process_csv

set file="%csv_file%"

set /a "current_line=1"

(for /f "usebackq tokens=*" %%a in (%file%) do (

    set "line=%%a"

    setlocal enabledelayedexpansion

    if "!current_line!" gtr "%start_line%" (

        echo !line!

        set /a "count+=1"

        set /a "line_count+=1"

        if !count! equ %milestone_lines% (

            call :show_progress

            set /a "count=0"

        )

    )

    set /a "current_line+=1"

    endlocal

)) > "%output_file%"

goto :eof

REM CSVファイルを処理する

call :process_csv

REM 処理完了メッセージを表示し、ユーザーにキー入力を待つ

echo 処理が完了しました。キーを押してください。

pause > nul

