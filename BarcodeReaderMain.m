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
    extracted = extractBarCode(image, false);
    figure; 
    imshow(extracted); 
    xlabel(buildLegendFromFileName(currentFileName));
    
    % Separa os dígitos
    hold on;
    width = 13.7;
    for j = 1 : 6
       region = [87+j*width 20 width 100];
       rectangle('Position', region, 'Linewidth', 1, 'EdgeColor', 'g');
       groups{j} = imcrop(extracted, region);
    end
    hold off;
    
    figure; 
    for j = 1 : 6
        subplot(2, 3, j); imshow(groups{j});
    end
    
    % TODO Dividir em 7 strips e fazer uma media na vertical e ver se ta
    % mais pra branco ou pra preto
    
end