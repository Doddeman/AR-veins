function wb = whitetoblack (matrix)

matrix(matrix == 1) = 0;
matrix(matrix == 0) = 1;

wb = matrix;

end