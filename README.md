# VSCode ポータブル自動更新スクリプト

<br />

## VSCode ポータブルの問題

Portable Mode版のVSCodeはインストーラー版と違って自動アップデートが使えない

<br />

## 解決策 

スクリプトファイルを実行するだけで、VSCode が自動更新されるようにする

<br />

## スクリプトの使い方

このスクリプトを VSCodeの実行ファイル（code.exe）がある場所に配置する。

VSCode ポータブルをアップデートしたい時はこのスクリプトを実行する。

<br />

## ソースコード

### vscode-updater.ps1

``` ps1
#設定値
$DATA_DIR = "data"
$USER_DATA_DIR = "data/user-data"
$TEMP_FILES =  @("Backups", "Cache", "CachedData", "GPUCache", "logs")
$VSCODE_PORTABLE_DOWNLOAD_URL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
$WILD_CARD_FOR_VSCODE_PORTABLE_ZIP_FILENAME = "./VSCode-win32-x64-*.zip"
$REGEX_FOR_VSCODE_PORTABLE_ZIP_FILENAME = "(VSCode-win32-x64-)(.*?)(.zip)"
$THIS_FILENAME = $MyInvocation.MyCommand.Name

# ユーザデータフォルダ（data/user-data）から一時ファイルを削除
Remove-Item -Recurse -Force -Path $USER_DATA_DIR -Include $TEMP_FILES

# 最新の安定版 VSCode ポータブルをダウンロード
curl.exe -LOJ $VSCODE_PORTABLE_DOWNLOAD_URL 

# ダウンロードしたファイル名を取得
$targetFileName = Get-ChildItem $WILD_CARD_FOR_VSCODE_PORTABLE_ZIP_FILENAME
$targetFileName -match $REGEX_FOR_VSCODE_PORTABLE_ZIP_FILENAME

# 更新後の VSCode のバージョン番号を取得
$version = $Matches[2]
# zipファイル名を取得
$zipFileName = "$($Matches[1])${version}$($Matches[3])"

# ユーザデータフォルダ、この更新スクリプト、VSCode ポータブルの zip ファイル以外をすべて削除
Get-ChildItem -Exclude @($DATA_DIR, $THIS_FILENAME, $zipFileName) | Remove-Item -Recurse -Force

# VSCode ポータブルの zip ファイルを解凍
Expand-Archive -Path $zipFileName -DestinationPath .

# VSCode ポータブルの zip ファイルを削除
Remove-Item -Path $zipFileName

$endMessage = @"

Successfuly updated.'
VSCode ポータブルの更新に成功しました.

更新後の　VSCode は ${version} です.

"@

Write-Host $endMessage
Pause

# VSCode を開く
./Code
```