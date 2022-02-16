#include <iostream>
#include <string>

using namespace std;

const string usingProgram = "Usage: FlipByte.exe <input byte>\n";
const string warningTypeInputData = "*<input byte> is number from 0 to 255\n";
const string errCountArg = "Invalid arguments count\n";
const string errTypeArg = "Invalid arguments type\n";
const string errValueArg = "Invalid argument value\n";

void ErrorDisplay()
{
	cout << usingProgram;
	cout << warningTypeInputData;
}

bool IsStrNumber(string str)
{
	for (int i = 1; i < str.length(); i++)
	{
		if (!isdigit(str[i]))
		{
			return false;
		}
	}
	return isdigit(str[0]) || (str[0] == '-' && (str.length() > 1));
}

int ParseArg(int argc, char* argv[])
{
	if (argc != 2)
	{
		ErrorDisplay();
		cout << errCountArg;
		return -1;
	}

	if (!IsStrNumber(static_cast<string>(argv[1])))
	{
		cout << errTypeArg;
		ErrorDisplay();
		return -1;
	}

	int number = stoi(static_cast<string>(argv[1]));

	if ((number < 0) || (number > 255))
	{
		cout << errValueArg;
		ErrorDisplay();
		return -1;
	}

	return number;
}

unsigned char FlipBits(unsigned char number)
{
	unsigned char result = 0x00;
	for (int i = 1; number != 0; i++)
	{
		if (number & 0x01)
		{
			result |= (0x01 << (CHAR_BIT - i));
		}
		number >>= 1;
	}
	return result;
}

int main(int argc, char* argv[])
{
	int number = ParseArg(argc, argv);

	// Проверка правильности аргументов командной строки
	if (number == -1)
	{
		return 1;
	}

	unsigned char result = FlipBits(static_cast<unsigned char>(number));

	cout << static_cast<unsigned int>(result) << endl;

	return 0;
}