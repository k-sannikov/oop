#include <fstream>
#include <iostream>
#include <optional>
#include <string>

using namespace std;

const string errCountArg = "Invalid arguments count\n";
const string errArg = "Invalid arguments <text to search>\n";
const string usingProgram = "Usage: findtext.exe <file name> <text to search>\n";
const string errReadData = "Failed to read data from input file\n";
const string errNotFound = "Text not found\n";
const string errFailedOpen = "Failed to open file for reading\n";

struct Args
{
	string inputFileName;
	string textToSearch;
};

optional<Args> ParseArgs(int argc, char* argv[])
{
	if (argc != 3)
	{
		cout << errCountArg;
		cout << usingProgram;
		return nullopt;
	}

	if (string(argv[2]).length() == 0)
	{
		cout << errArg;
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
		cout << errFailedOpen;
		return 1;
	}

	if (input.bad())
	{
		cout << errReadData;
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
		cout << errNotFound;
		return 1;
	}

	return 0;
}