% Leitor de c�digos de barras EAN-13
% https://pt.wikipedia.org/wiki/EAN-13
% Vers�o 0.0

close all;
clear all;
clc;

setFolder = 'set1';
imageFiles = dir([setFolder '/*.png']);      
numerOfFiles = length(imageFiles);
for i = 1 : numerOfFiles
    currentFileName = imageFiles(i).name;
    image = imread([setFolder '/' currentFileName]);
    image = rgb2gray(image);
   
    % Extrai o c�digo de barras da imagem
    extracted = extractBarCode(image, false);
    figure; 
    imshow(extracted);
    xlabel(buildLegendFromFileName(currentFileName)); 
    
    % Separa os d�gitos
    [primeiroGrupo, segundoGrupo] = splitDigits(extracted, false);
    
    % Para cada d�gito, separa os bits e determina o n�mero correspondente
    for j = 1 : 6
        digits = getDigitBits(segundoGrupo{j}, false);
        number = translateBarCodeCodification(digits);
        digits
        number
    end

end