@echo off

REM Путь к тестируемой программе передается через 1-й аргумент командной строки
SET MyProgram="%~1"

REM Защита от запуска без аргумента, задающего путь к программе
if %MyProgram%=="" (
	echo "Please specify path to program"
	exit /B 1
) 

REM Тест 1: Запуск без аргументов
%MyProgram% > nul && goto err
echo "Test 1 passed: running without arguments"

REM Тест 2: Запуск c лишними аргументами
%MyProgram% 4 5 6 > nul && goto err
echo "Test 2 passed: running with extra arguments 4 5 6"

REM Тест 3: Запуск с передачей пустой строки
%MyProgram% NonEmpty.txt "" > nul && goto err
echo "Test 3 passed: running with the transmission of an empty string"

REM Тест 4: Запуск с передачей невалидного типа данных
%MyProgram% abc123 > nul && goto err
echo "Test 4 passed: running with invalid data type abc123"

REM Тест 5: Запуск с передачей невалидного значения
%MyProgram% -10 > nul && goto err
echo "Test 5 passed: starting with an invalid value -10"

REM Тест 6: Запуск с передачей невалидного значения
%MyProgram% 350 > nul && goto err
echo "Test 6 passed: starting with an invalid value 350"

REM Тест 7: Запуск с передачей валидного значения
%MyProgram% 6 > "%TEMP%\output.txt" || goto err
set /p result=<"%TEMP%\output.txt"
if not %result% == 96 goto err
echo "Test 7 passed: starting with a valid value 6"

REM Тест 8: Запуск с передачей валидного значения
%MyProgram% 65 > "%TEMP%\output.txt" || goto err
set /p result=<"%TEMP%\output.txt"
if not %result% == 130 goto err
echo "Test 8 passed: starting with a valid value 65"

REM Тест 9: Запуск с передачей символа минус
%MyProgram% - > nul && goto err
echo "Test 9 passed: starting with -"

REM Тесты прошли успешно
echo "All tests passed successfull"
exit /B 0

REM Переход сюда в случае ошибки
:err
echo "Test failed"
exit /B 1