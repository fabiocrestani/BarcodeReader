function [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
    readAndPrepareFile(imageFile, setFolder)
% Abre arquivo de imagem e pré-processa
    
    currentFileName = imageFile.name;
    image = imread([setFolder '/' currentFileName]);

    % Redimensiona, se for muito grande
    [m, n] = size(image);
    if m*n > 790*960*15
        image = imresize(image, 790*960*15 / (m*n));
    end

    % Trata caso onde imagem de entrada é colorida
    [~, ~, channelNumber] = size(image);
    if channelNumber == 3
        image = rgb2gray(image);
    end
    
    % Obtém resultado esperado a partir do nome do arquivo
    firstDigitExptd = currentFileName(1);
    firstGroupExptd = currentFileName(2:7);
    secondGroupExptd = currentFileName(8:13);
end