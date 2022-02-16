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
echo "Test 1 passed: Search in an empty file"

REM ���� 2: ����� ������ ������
%MyProgram% NonEmpty.txt "" > nul && goto err
echo "Test 2 passed: Searching for an empty string"

REM ���� 3: �������������� ����� �� � ������ �����
SET SearchWord="dolor sit"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" || goto err
findstr /n /c:%SearchWord% NonEmpty.txt > "%TEMP%\findstrOutput.txt"
fc "%TEMP%\findtextOutput.txt" "%TEMP%\findstrOutput.txt" > nul || goto err
echo "Test 3 passed: Effective search is not in an empty file"

REM ���� 4: ���������������� ����� �� � ������ �����
SET SearchWord="abcd efgh"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" && goto err
echo "Test 4 passed: Unsuccessful search not in an empty file"

REM ���� 5: ����� ������ � �������������� �����
%MyProgram% Missing.txt "test" > nul && goto err
echo "Test 5 passed: Searching for a string in a nonexistent file"

REM ���� 6: ���� ��������� �� �������, �� ��������� ���������� �����
%MyProgram% > nul && goto err
echo "Test 6 passed: No parameters specified"

REM ���� 7: ����� ������ ������ � ����� � ������ �������
%MyProgram% EmptyString.txt "" > nul && goto err
echo "Test 7 passed: Searching for an empty string in a file with an empty string"

REM ���� 8: ����� ������ � ����� � ������ �������
%MyProgram% EmptyString.txt "test" > nul && goto err
echo "Test 8 passed: Searching for a line in a file with an empty line"

REM ���� 9: ����� � ������� �����
SET SearchWord="other"
%MyProgram% WarAndPeace.txt %SearchWord% > "%TEMP%\findtextOutput.txt" || goto err
echo "Test 9 passed: Search in a large file"

REM ����� ������ �������
echo "All tests passed successfull"
exit /B 0

REM ������� ���� � ������ ������
:err
echo "Test failed"
exit /B 1