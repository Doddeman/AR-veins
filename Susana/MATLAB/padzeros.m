%set non-arm values to zero (by using appropriate treshhold (this need to
%be tweeked))
%We need to take the images with a black background. It seems to be working

function PZ = padzeros (matrix)

matrix(matrix < 80.0) = [NaN];

PZ = matrix;

end