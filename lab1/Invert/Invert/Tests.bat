@echo off
REM ���� � ����㥬�� �ணࠬ�� ��।����� �१ 1-� ��㬥�� ��������� ��ப�
SET MyProgram="%~1"
REM ���� �� ����᪠ ��� ��㬥��, �����饣� ���� � �ணࠬ��
if %MyProgram%=="" (
	echo "Please specify path to program"
	exit /B 1
) 

%MyProgram% > nul && goto err
echo "���� 1 �ன���: ����� ��� ��㬥�⮢"

REM ���� 2: ����� c ��譨�� ��㬥�⠬�
%MyProgram% ValidMatrix1.txt q > nul && goto err
echo "���� 2 �ன���: ����� � ��譨� ��㬥�⮬"

REM ���� 3: ����� c ��।�祩 ���������饣� 䠩��
%MyProgram% Missing.txt > nul && goto err
echo "���� 3 �ன���: ����� � ��।�祩 ���������饣� 䠩��"

REM ���� 4: ����� c ��।�祩 ���⮣� 䠩��
%MyProgram% Empty.txt > nul && goto err
echo "���� 4 �ன���: ����� c ��।�祩 ���⮣� 䠩��"

REM ���� 5: ����� c ��।�祩 䠩�� � ���⮩ ��ப��
%MyProgram% EmptyString.txt > nul && goto err
echo "���� 5 �ன���: ����� c ��।�祩 ���⮣� 䠩��"

REM ���� 6: ����� � ��।�祩 ��������� ���祭��
%MyProgram% ValidMatrix1.txt > "%TEMP%\output.txt" || goto err
fc CorrectOutputValidMatrix1.txt "%TEMP%\output.txt" > nul || goto err
echo "���� 6 �ன���: ����� c ��।�祩 ���⮣� 䠩��"

REM ���� 7: ����� c ��।�祩 ������ ����襣� ࠧ���
%MyProgram% SmallMatrix.txt > nul && goto err
echo "���� 7 �ன���: ����� c ��।�祩 ������ ����襣� ࠧ���"

REM ���� 8: ����� c ��।�祩 ������ ����襣� ࠧ���
%MyProgram% BigMatrix.txt > nul && goto err
echo "���� 8 �ன���: ����� c ��।�祩 ������ ����襣� ࠧ���"

REM ���� 9: ����� c ��।�祩 ������ ��।���⥫� ���ன ࠢ�� 0
%MyProgram% DeterminantZero.txt > nul && goto err
echo "���� 9 �ன���: ����� c ��।�祩 ������ ��।���⥫� ���ன ࠢ�� 0"

REM ���� 10: ����� c ��।�祩 ���������� ������
%MyProgram% NoneValidMatrix.txt > nul && goto err
echo "���� 10 �ன���: ����� c ��।�祩 ���������� ������"

REM ���� 11: ����� � ��।�祩 ��������� ���祭��
%MyProgram% ValidMatrix2(Dirty).txt > "%TEMP%\output.txt" || goto err
fc CorrectOutputValidMatrix2.txt "%TEMP%\output.txt" > nul || goto err
echo "���� 11 �ன���: ����� c ��।�祩 ���⮣� 䠩��"

REM ����� ��諨 �ᯥ譮
echo "�� ���� ��諨 �ᯥ譮"
exit /B 0

REM ���室 � � ��砥 �訡��
:err
echo "����� �� ��諨"
exit /B 1