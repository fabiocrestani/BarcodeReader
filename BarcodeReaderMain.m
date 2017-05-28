% Leitor de códigos de barras EAN-13
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
   
    % Extrai o código de barras da imagem
    extracted = extractBarCode(image);
    figure; imshow(extracted);
end