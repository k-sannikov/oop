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
echo Test 1 passed

REM Тест 2: Поиск пустой строки
%MyProgram% NonEmpty.txt "" > nul && goto err
echo Test 2 passed

REM Тест 3: Результативный поиск не в пустом файле
SET SearchWord="dolor sit"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" || goto err
findstr /n /c:%SearchWord% NonEmpty.txt > "%TEMP%\findstrOutput.txt"
fc "%TEMP%\findtextOutput.txt" "%TEMP%\findstrOutput.txt" > nul || goto err
echo Test 3 passed

REM Тест 4: Нерезультативный поиск не в пустом файле
SET SearchWord="abcd efgh"
%MyProgram% NonEmpty.txt %SearchWord% > "%TEMP%\findtextOutput.txt" && goto err
echo Test 4 passed

REM Тест 5: Поиск строки в несуществующем файле
%MyProgram% Missing.txt "test" > nul && goto err
echo Test 5 passed

REM Тест 6: Если параметры не указаны, то программа завершится сбоем
%MyProgram% > nul && goto err
echo Test 6 passed

REM Тесты прошли успешно
echo All tests passed successfull
exit /B 0

REM Переход сюда в случае ошибки
:err
echo Test failed
exit /B 1