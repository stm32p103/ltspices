rem forfiles�R�}���h -- http://www.atmarkit.co.jp/ait/articles/0902/27/news132.html
rem �R�}���h�̎��s���ʂ�ϐ��ɑ������ -- http://hanjyuku.info/mt/memo/2011/04/cmd20110407-2155.html
echo off

del *.asc *.asy
rem �J�����g�f�B���N�g���擾
for /f "usebackq tokens=*" %%a in (`cd`) do @set TARGET=%%a

rem �t�@�C�����R�s�[����
forfiles /p .. /s /m *.asc /c "cmd /c @copy /Y @path %TARGET%"
forfiles /p .. /s /m *.asy /c "cmd /c @copy /Y @path %TARGET%"

pause -1