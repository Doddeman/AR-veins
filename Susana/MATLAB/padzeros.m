%set non-arm values to zero (by using appropriate treshhold (this need to
%be tweeked))
%We need to take the images with a black background. It seems to be working

function PZ = padzeros (matrix)

matrix(matrix < 85.0) = [0.0];

PZ = matrix;

end