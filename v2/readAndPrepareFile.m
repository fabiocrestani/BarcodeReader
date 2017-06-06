function [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
        readAndPrepareFile(imageFile, setFolder)
% Abre arquivo de imagem e pré-processa
    
    currentFileName = imageFile.name;
    image = imread([setFolder '/' currentFileName]);

    % Redimensiona, se for muito grande
    [m, n] = size(image);
    if m*n > (230*174*10)
        image = imresize(image, 230*174*50 / (m*n));
    end

    % Trata caso onde imagem de entrada é colorida
    [~, ~, channelNumber] = size(image);
    if channelNumber == 3
        image = rgb2gray(image);
    end
    image = mat2gray(image);
    
    % Obtém resultado esperado a partir do nome do arquivo
    firstDigitExptd = currentFileName(1);
    firstGroupExptd = currentFileName(2:8);
    secondGroupExptd = currentFileName(9:15);
end