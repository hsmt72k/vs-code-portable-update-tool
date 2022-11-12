# �� VSCode �|�[�^�u�������X�V�X�N���v�g
# 
# �����
# Portable Mode�ł�VSCode�̓C���X�g�[���[�łƈ���Ď����A�b�v�f�[�g���g���Ȃ�
# 
# �������� 
# �X�N���v�g�t�@�C�����_�u���N���b�N���邾���ŁAVSCode �������X�V�����悤�ɂ���
# 
# ���X�N���v�g�̎g����
# �X�N���v�g�� update.ps1 �Ƃ����t�@�C�����ŁAVSCode�̎��s�t�@�C���icode.exe�j������ꏊ�ɔz�u����B
# VSCode���A�b�v�f�[�g���������͂��̃X�N���v�g�����s����B

#�ݒ�l
$DATA_DIR = "data"
$USER_DATA_DIR = "data/user-data"
$TEMP_FILES =  @("Backups", "Cache", "CachedData", "GPUCache", "logs")
$VSCODE_PORTABLE_DOWNLOAD_URL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
$WILD_CARD_FOR_VSCODE_PORTABLE_ZIP_FILENAME = "./VSCode-win32-x64-*.zip"
$REGEX_FOR_VSCODE_PORTABLE_ZIP_FILENAME = "(VSCode-win32-x64-)(.*?)(.zip)"
$THIS_FILENAME = $MyInvocation.MyCommand.Name

# ���[�U�f�[�^�t�H���_�idata/user-data�j����ꎞ�t�@�C�����폜
Remove-Item -Recurse -Force -Path $USER_DATA_DIR -Include $TEMP_FILES

# �ŐV�̈���� VSCode �|�[�^�u�����_�E�����[�h
curl.exe -LOJ $VSCODE_PORTABLE_DOWNLOAD_URL 

# �_�E�����[�h�����t�@�C�������擾
$targetFileName = Get-ChildItem $WILD_CARD_FOR_VSCODE_PORTABLE_ZIP_FILENAME
$targetFileName -match $REGEX_FOR_VSCODE_PORTABLE_ZIP_FILENAME

# �X�V��� VSCode �̃o�[�W�����ԍ����擾
$version = $Matches[2]
# zip�t�@�C�������擾
$zipFileName = "$($Matches[1])${version}$($Matches[3])"

# ���[�U�f�[�^�t�H���_�A���̍X�V�X�N���v�g�AVSCode �|�[�^�u���� zip �t�@�C���ȊO�����ׂč폜
Get-ChildItem -Exclude @($DATA_DIR, $THIS_FILENAME, $zipFileName) | Remove-Item -Recurse -Force

# VSCode �|�[�^�u���� zip �t�@�C������
Expand-Archive -Path $zipFileName -DestinationPath .

# VSCode �|�[�^�u���� zip �t�@�C�����폜
Remove-Item -Path $zipFileName

$endMessage = @"

Successfuly updated.'
VSCode �|�[�^�u���̍X�V�ɐ������܂���.

�X�V��́@VSCode �� ${version} �ł�.

"@

Write-Host $endMessage
Pause

# VSCode ���J��
./Code

