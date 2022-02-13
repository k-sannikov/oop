@echo off

REM ���� � ����������� ��������� ���������� ����� 1-� �������� ��������� ������
SET MyProgram="%~1"

REM ������ �� ������� ��� ���������, ��������� ���� � ���������
if %MyProgram%=="" (
	echo Please specify path to program
	exit /B 1
) 

REM ���� 1: ����� � ������ �����
%MyProgram% Empty.txt "test" > nul && goto err
echo Test 1 passed

REM ���� 2: ����� ������ ������
%MyProgram% NonEmpty.txt "" > nul && goto err
echo Test 2 passed

REM ���� 3: �������������� ����� �� � ������ �����
SET SearchWord="dolor sit"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" || goto err
findstr /n /c:%SearchWord% NonEmpty.txt > "%TEMP%\findstrOutput.txt"
fc "%TEMP%\findtextOutput.txt" "%TEMP%\findstrOutput.txt" > nul || goto err
echo Test 3 passed

REM ���� 4: ���������������� ����� �� � ������ �����
SET SearchWord="abcd efgh"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" && goto err
echo Test 4 passed

REM ���� 5: ����� ������ � �������������� �����
%MyProgram% Missing.txt "test" > nul && goto err
echo Test 5 passed

REM ���� 6: ���� ��������� �� �������, �� ��������� ���������� �����
%MyProgram% > nul && goto err
echo Test 6 passed

REM ����� ������ �������
echo All tests passed successfull
exit /B 0

REM ������� ���� � ������ ������
:err
echo Test failed
exit /B 1