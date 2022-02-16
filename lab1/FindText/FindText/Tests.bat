@echo off

REM Путь к тестируемой программе передается через 1-й аргумент командной строки
SET MyProgram="%~1"

REM Защита от запуска без аргумента, задающего путь к программе
if %MyProgram%=="" (
	echo Please specify path to program
	exit /B 1
) 

REM Тест 1: Поиск в пустом файле
%MyProgram% Empty.txt "test" > nul && goto err
echo "Test 1 passed: Search in an empty file"

REM Тест 2: Поиск пустой строки
%MyProgram% NonEmpty.txt "" > nul && goto err
echo "Test 2 passed: Searching for an empty string"

REM Тест 3: Результативный поиск не в пустом файле
SET SearchWord="dolor sit"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" || goto err
findstr /n /c:%SearchWord% NonEmpty.txt > "%TEMP%\findstrOutput.txt"
fc "%TEMP%\findtextOutput.txt" "%TEMP%\findstrOutput.txt" > nul || goto err
echo "Test 3 passed: Effective search is not in an empty file"

REM Тест 4: Нерезультативный поиск не в пустом файле
SET SearchWord="abcd efgh"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" && goto err
echo "Test 4 passed: Unsuccessful search not in an empty file"

REM Тест 5: Поиск строки в несуществующем файле
%MyProgram% Missing.txt "test" > nul && goto err
echo "Test 5 passed: Searching for a string in a nonexistent file"

REM Тест 6: Если параметры не указаны, то программа завершится сбоем
%MyProgram% > nul && goto err
echo "Test 6 passed: No parameters specified"

REM Тест 7: Поиск пустой строки в файле с пустой строкой
%MyProgram% EmptyString.txt "" > nul && goto err
echo "Test 7 passed: Searching for an empty string in a file with an empty string"

REM Тест 8: Поиск строки в файле с пустой строкой
%MyProgram% EmptyString.txt "test" > nul && goto err
echo "Test 8 passed: Searching for a line in a file with an empty line"

REM Тест 9: Поиск в большом файле
SET SearchWord="other"
%MyProgram% WarAndPeace.txt %SearchWord% > "%TEMP%\findtextOutput.txt" || goto err
echo "Test 9 passed: Search in a large file"

REM Тесты прошли успешно
echo "All tests passed successfull"
exit /B 0

REM Переход сюда в случае ошибки
:err
echo "Test failed"
exit /B 1