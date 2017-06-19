function B = imboxfilt(A, filterSize)
% B = imboxfilt(A,filterSize) filters image A with a 2-D box filter with
% size specified by filterSize.
% Introduced in R2015b
% https://www.mathworks.com/help/images/ref/imboxfilt.html

% Refiz essa fun��o para ficar mais f�cil de portar o c�digo para vers�es
% antigas do Matlab (anteriores � R2015b)

if length(filterSize) == 1
    filterSize = [filterSize filterSize];
end

h = fspecial('average', filterSize);
B = imfilter(A, h, 'symmetric');

end