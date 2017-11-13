
function rg = removegrey (matrix)

matrix(matrix > 0.89) = 1;

rg = matrix;

end