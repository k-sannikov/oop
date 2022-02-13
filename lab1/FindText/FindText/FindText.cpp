#include <fstream>
#include <iostream>
#include <optional>
#include <string>

using namespace std;

struct Args
{
	string inputFileName;
	string textToSearch;
};

optional<Args> ParseArgs(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << "Invalid arguments count\n";
		cout << "Usage: findtext.exe <file name> <text to search>\n";
		return nullopt;
	}

	if (string(argv[2]).length() == 0)
	{
		cout << "Invalid arguments <text to search>\n";
		return nullopt;
	}

	Args args;
	args.inputFileName = argv[1];
	args.textToSearch = argv[2];
	return args;
}

int main(int argc, char* argv[])
{
	auto args = ParseArgs(argc, argv);
	// Проверка правильности аргументов командной строки
	if (!args)
	{
		return 1;
	}

	// открытие входного файла
	ifstream input;
	input.open(args->inputFileName);

	if (!input.is_open())
	{
		cout << "Failed to open '" << args->inputFileName << "' for reading\n";
		return 1;
	}

	// поиск подстроки в файле
	bool isFound = false;
	int stringCounter = 0;
	string str;
	while (getline(input, str))
	{
		stringCounter++;

		if (str.find(args->textToSearch) != string::npos)
		{
			cout << stringCounter << ":" + str << endl;
			if (!isFound)
			{
				isFound = true;
			}
		}
	}

	if (!isFound)
	{
		cout << "Text not found" << endl;
		return 1;
	}

	if (input.bad())
	{
		cout << "Failed to read data from input file\n";
	}

	return 0;
}