@echo off

REM Путь к тестируемой программе передается через 1-й аргумент командной строки
SET MyProgram="%~1"

REM Защита от запуска без аргумента, задающего путь к программе
if %MyProgram%=="" (
	echo Please specify path to program
	exit /B 1
) 

REM Тест 1: Запуск без аргументов
%MyProgram% > nul && goto err
echo Test 1 passed

REM Тест 2: Запуск c лишними аргументов
%MyProgram% 4 5 6 > nul && goto err
echo Test 2 passed

REM Тест 3: Запуск с передачей пустой строки
%MyProgram% NonEmpty.txt "" > nul && goto err
echo Test 3 passed

REM Тест 4: Запуск с передачей невалидного типа данных
%MyProgram% abc123 > nul && goto err
echo Test 4 passed

REM Тест 5: Запуск с передачей невалидного значения
%MyProgram% -10 > nul && goto err
echo Test 5 passed

REM Тест 6: Запуск с передачей невалидного значения
%MyProgram% 350 > nul && goto err
echo Test 6 passed

REM Тест 7: Запуск с передачей валидного значения
%MyProgram% 6 > "%TEMP%\output.txt" || goto err
set /p result=<"%TEMP%\output.txt"
if not %result% == 96 goto err
echo Test 7 passed

REM Тест 8: Запуск с передачей валидного значения
%MyProgram% 65 > "%TEMP%\output.txt" || goto err
set /p result=<"%TEMP%\output.txt"
if not %result% == 130 goto err
echo Test 8 passed

REM Тест 9: Запуск с передачей символа минус
%MyProgram% - > nul && goto err
echo Test 9 passed

REM Тесты прошли успешно
echo All tests passed successfull
exit /B 0

REM Переход сюда в случае ошибки
:err
echo Test failed
exit /B 1