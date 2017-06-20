function [image, resized, scale, firstDigitExptd, firstGroupExptd, ...
    secondGroupExptd] = readAndPrepareFile(imageFile, setFolder)
% Abre arquivo de imagem e pré-processa
    
    currentFileName = imageFile.name;
    image = imread([setFolder '/' currentFileName]);

    % Redimensiona, se for muito grande
    [m, n] = size(image);
    if m*n > 790*960
        resized = imresize(image, 790*960*6 / (m*n));
        scale = 790*960*6 / (m*n);
    else
        resized = image;
        scale = 1;
    end
    
    % Trata caso onde imagem de entrada é colorida
    resized = convertIfColorImage(resized);
    
    % Obtém resultado esperado a partir do nome do arquivo
    firstDigitExptd = currentFileName(1);
    firstGroupExptd = currentFileName(2:7);
    secondGroupExptd = currentFileName(8:13);
end