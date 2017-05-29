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
    image = rgb2gray(image);
   
    % Extrai o código de barras da imagem
    extracted = extractBarCode(image, false);
    figure; 
    imshow(extracted);
    xlabel(buildLegendFromFileName(currentFileName)); 
    
    % Separa os dígitos
    [primeiroGrupo, segundoGrupo] = splitDigits(extracted, true);
    
%    segundoGrupoBits = splitDigitBits(segundoGrupo, true);
    
    % TODO Dividir em 7 strips e fazer uma media e ver se ta mais pra 
    % branco ou pra preto
%     figure;
%     imshow(groups{1});
%     hold on;
% 	width = 1.9;
%     for j = 1 : 7
%        region = [1+(j-1)*width 10 width 50];
%        rectangle('Position', region, 'Linewidth', 1, 'EdgeColor', 'g');
%        digitBar = imcrop(groups{1}, region);
%        digits(j) = mean(digitBar(:));
%        digitBars{j} = digitBar;
%        digits(j)
%     end
%     hold off;
%     
%     digits = digits < (255/2);
%     
%     figure; 
%     for j = 1 : 7
%         subplot(2, 4, j); 
%         imshow(digitBars{j}); 
%         if digits(j)
%             xlabel('1');
%         else
%             xlabel('0');
%         end
%     end
%     
%     digits

end