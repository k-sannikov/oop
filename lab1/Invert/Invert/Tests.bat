@echo off
REM Путь к тестируемой программе передается через 1-й аргумент командной строки
SET MyProgram="%~1"
REM Защита от запуска без аргумента, задающего путь к программе
if %MyProgram%=="" (
	echo "Please specify path to program"
	exit /B 1
) 

%MyProgram% > nul && goto err
echo "Тест 1 пройден: запуск без аргументов"

REM Тест 2: Запуск c лишними аргументами
%MyProgram% ValidMatrix1.txt q > nul && goto err
echo "Тест 2 пройден: запуск с лишним аргументом"

REM Тест 3: Запуск c передачей несуществующего файла
%MyProgram% Missing.txt > nul && goto err
echo "Тест 3 пройден: запуск с передачей несуществующего файла"

REM Тест 4: Запуск c передачей пустого файла
%MyProgram% Empty.txt > nul && goto err
echo "Тест 4 пройден: запуск c передачей пустого файла"

REM Тест 5: Запуск c передачей файла с пустой строкой
%MyProgram% EmptyString.txt > nul && goto err
echo "Тест 5 пройден: запуск c передачей пустого файла"

REM Тест 6: Запуск с передачей валидного значения
%MyProgram% ValidMatrix1.txt > "%TEMP%\output.txt" || goto err
fc CorrectOutputValidMatrix1.txt "%TEMP%\output.txt" > nul || goto err
echo "Тест 6 пройден: запуск c передачей пустого файла"

REM Тест 7: Запуск c передачей матрицы меньшего размера
%MyProgram% SmallMatrix.txt > nul && goto err
echo "Тест 7 пройден: запуск c передачей матрицы меньшего размера"

REM Тест 8: Запуск c передачей матрицы большего размера
%MyProgram% BigMatrix.txt > nul && goto err
echo "Тест 8 пройден: запуск c передачей матрицы большего размера"

REM Тест 9: Запуск c передачей матрицы определитель которой равен 0
%MyProgram% DeterminantZero.txt > nul && goto err
echo "Тест 9 пройден: запуск c передачей матрицы определитель которой равен 0"

REM Тест 10: Запуск c передачей невалидной матрицы
%MyProgram% NoneValidMatrix.txt > nul && goto err
echo "Тест 10 пройден: запуск c передачей невалидной матрицы"

REM Тест 11: Запуск с передачей валидного значения
%MyProgram% ValidMatrix2(Dirty).txt > "%TEMP%\output.txt" || goto err
fc CorrectOutputValidMatrix2.txt "%TEMP%\output.txt" > nul || goto err
echo "Тест 11 пройден: запуск c передачей пустого файла"

REM Тесты прошли успешно
echo "Все тесты прошли успешно"
exit /B 0

REM Переход сюда в случае ошибки
:err
echo "Тесты не прошли"
exit /B 1