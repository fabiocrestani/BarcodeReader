% Leitor de códigos de barras EAN-13
% https://pt.wikipedia.org/wiki/EAN-13
% Versão 0.0

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
   
    % Extrai o código de barras da imagem
    extracted = extractBarCode(image, false);
    figure; 
    imshow(extracted);
    xlabel(buildLegendFromFileName(currentFileName)); 
    
    % Separa os dígitos
    [primeiroGrupo, segundoGrupo] = splitDigits(extracted, false);
    
    % Para cada dígito, separa os bits e determina o número correspondente
    for j = 1 : 6
        digits = getDigitBits(segundoGrupo{j}, false);
        number = translateBarCodeCodification(digits);
        digits
        number
    end

end