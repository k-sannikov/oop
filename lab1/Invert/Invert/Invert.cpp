#include <fstream>
#include <iostream>
#include <optional>
#include <string>
#include <vector>
#include <windows.h>

using namespace std;

const unsigned int sizeMatrix3x3 = 3;
const unsigned int roundingAccuracy = 3;

typedef vector<vector<double>> Matrix;

struct Args
{
	string inputFileName;
};

optional<Args> ParseArgs(int argc, char* argv[])
{
	if (argc != 2)
	{
		std::cout << "Ќедопустимое количество аргументов\n";
		std::cout << "»спользуйте: Invert.exe <matrix file>\n";
		return std::nullopt;
	}
	Args args;
	args.inputFileName = argv[1];
	return args;
}

double RoundNumber(double value, unsigned numberCount)
{
	double base = pow(10., (int)numberCount);
	return floor(value * base + 0.5) / base;
}

// удаление повтор€ющихс€ разделителей строки (пробелы/табы)
string RemoveDuplicateSeparators(string str)
{
	bool separatorFound = false;
	string newStr = "";
	for (int i = 0; i < str.length(); i++)
	{
		if (str[i] != ' ' && str[i] != '\t')
		{
			if (separatorFound)
			{
				newStr += ' ';
				separatorFound = false;
			}
			newStr += str[i];
		}
		else
		{
			separatorFound = true;
		}
	}
	return newStr;
}

bool CheckingNumericString(string str)
{
	int separator = 0;
	for (int i = 1; i < str.length(); i++)
	{
		if (!isdigit(str[i]))
		{
			if (str[i] == '.')
			{
				separator++;
				if (separator > 1)
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
	}
	return isdigit(str[0]) || (str[0] == '-' && (str.length() > 1));
}

// создание массива из строки по разделителю
vector<string> Split(string str, string delimiter)
{
	vector<string> strings;
	int pos = 0;
	string token;
	while ((pos = str.find(delimiter)) != string::npos) {
		token = str.substr(0, pos);
		strings.push_back(token);
		str.erase(0, pos + delimiter.length());
	}
	strings.push_back(str);

	return strings;
}

// получение массива чисел из массива строк
vector<double> GetArrayNumber(vector<string> strings)
{
	vector<double> numbers;
	for (int i = 0; i < strings.size(); i++)
	{
		if (CheckingNumericString(strings[i]))
		{
			numbers.push_back(stod(strings[i]));
		}
		else
		{
			return vector<double> {};
		}
	}

	return numbers;
}

// нахождение определител€ матрицы 3x3
double CalcDetMatrix3x3(Matrix matrix)
{
	double result = 0.0;
	result += matrix[0][0] * matrix[1][1] * matrix[2][2];
	result += matrix[0][1] * matrix[1][2] * matrix[2][0];
	result += matrix[0][2] * matrix[1][0] * matrix[2][1];
	result -= matrix[0][2] * matrix[1][1] * matrix[2][0];
	result -= matrix[0][1] * matrix[1][0] * matrix[2][2];
	result -= matrix[0][0] * matrix[1][2] * matrix[2][1];

	return result;
}

// нахождение определител€ матрицы 2x2
double CalcDetMatrix2x2(Matrix matrix)
{
	double result = 0.0;
	result += matrix[0][0] * matrix[1][1];
	result -= matrix[1][0] * matrix[0][1];

	return result;
}

// транспонирование матрицы
Matrix TransposeMatrix(Matrix matrix)
{
	Matrix newMatrix = {
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 0},
	};
	for (int i = 0; i < matrix.size(); i++)
	{
		for (int j = 0; j < matrix[i].size(); j++)
		{
			newMatrix[j][i] = matrix[i][j];
		}
	}

	return newMatrix;
}

Matrix CalcAdjointMatrix(Matrix matrix, double det)
{
	Matrix adjointMatrix(sizeMatrix3x3, vector <double>(sizeMatrix3x3, 0));
	for (int i = 0; i < sizeMatrix3x3; i++)
	{
		for (int j = 0; j < sizeMatrix3x3; j++)
		{
			double minor = CalcDetMatrix2x2(Matrix{
				{matrix[i < 1 ? 1 : 0][j < 1 ? 1 : 0], matrix[i < 1 ? 1 : 0][j < 2 ? 2 : 1]},
				{matrix[i < 2 ? 2 : 1][j < 1 ? 1 : 0], matrix[i < 2 ? 2 : 1][j < 2 ? 2 : 1]},
				}) / det;
			adjointMatrix[i][j] = ((i % 2 == 0) && (j % 2 != 0)) || ((i % 2 != 0) && (j % 2 == 0)) ? -minor : minor;
		}
	}

	return adjointMatrix;
}

void ShowMatrix(Matrix matrix)
{
	for (int i = 0; i < matrix.size(); i++)
	{
		for (int j = 0; j < matrix[i].size(); j++)
		{
			if (matrix[i][j] >= 0)
			{
				cout << ' ';
			}
			cout << RoundNumber(matrix[i][j], roundingAccuracy);
			if (j != 2)
			{
				cout << ' ';
			}
		}
		cout << "\n";
	}
}

bool CheckingSizeMatrix(Matrix matrix)
{
	bool error = false;
	if (matrix.size() != sizeMatrix3x3)
	{
		error = true;
	}
	for (int i = 0; i < matrix.size(); i++)
	{
		if (matrix[i].size() != sizeMatrix3x3)
		{
			error = true;
		}

	}

	return error;
}

int main(int argc, char* argv[])
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);

	auto args = ParseArgs(argc, argv);

	if (!args)
	{
		return 1;
	}

	// открытие входного файла
	ifstream input;
	input.open(args->inputFileName);

	if (!input.is_open())
	{
		std::cout << "Ќе удалось открыть '" << args->inputFileName << "' дл€ чтени€\n";
		return 1;
	}

	if (input.peek() == EOF)
	{
		std::cout << "»сходный файл пуст";
		return 1;
	}

	// создание матрицы
	string str;
	Matrix matrix;
	vector<string> strings;
	for (int i = 0; getline(input, str); i++)
	{
		if (str.size() != 0)
		{
			str = RemoveDuplicateSeparators(str); // удаление лишних разделителей между числами
			strings = Split(str, " ");
			vector<double> rowMatrix = GetArrayNumber(strings);

			if (rowMatrix.size() == 0)
			{
				cout << "Ќеверный формат ввода матрицы";
				return 1;
			}
			matrix.push_back(rowMatrix);
		}
	}

	if (input.bad())
	{
		cout << "Ќе удалось прочитать данные из входного файла\n";
		return 1;
	}

	if (matrix.size() == 0)
	{
		cout << "Ќеверный формат ввода матрицы\n";
		return 1;
	}

	if (CheckingSizeMatrix(matrix))
	{
		cout << "»сходна€ матрица размером не 3х3\n";
		return 1;
	}

	double det = CalcDetMatrix3x3(matrix);

	// при det = 0 обратной матрицы не существует
	if (det == 0)
	{
		cout << "ќпределитель равен 0, обратной матрицы не существует";
		return 1;
	}

	matrix = TransposeMatrix(matrix);

	// вычисление сопр€женной матрицы
	Matrix adjMatrix(sizeMatrix3x3, vector <double>(sizeMatrix3x3, 0));
	adjMatrix = CalcAdjointMatrix(matrix, det);

	ShowMatrix(adjMatrix);

	return 0;
}