%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Universidade Tecnol�gica Federal do Paran�                             %
% Curitiba, PR                                                           %
% Engenharia Eletr�nica                                                  %
% Processamento Digital de Imagens                                       %
%                                                                        %
% Projeto final da disciplina                                            %
% Leitor de c�digos de barras EAN-13                                     %
% https://pt.wikipedia.org/wiki/EAN-13                                   %
%                                                                        %
% Autor: F�bio Crestani                                                  %
% Email: crestani.fabio@gmail.com                                        %
% GitHub: https://github.com/fabiocrestani                               %
%                                                                        %
% Branch: deteccao-imagens-reais                                         %
% Vers�o 1.0.0                                                           %
% 19/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Carrega miniOCR
miniOCR = load('../miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = '../imageSets/set3-decodificacao-imagens-reais';
fileType = 'jpg';
imageFiles = dir([setFolder '/*.' fileType]);
if length(imageFiles) < 1
    error('Erro: main. Nenhum arquivo encontrado');
end
numberOfFiles = length(imageFiles);

% Sele��o das fun��es
deteccao         = true;    % Encontra c�digo de barras na foto
showResultImages = true;    % true se quiser mostrar as imagens resultantes

% Para compara��o
acertos = 0;
erros = 0;

%numberOfFiles = 1;
for i = 1 : numberOfFiles
    %i = 1;
    
    % L� arquivo e pr�-processa
    [originalImage, image, scale, firstDigitExptd, firstGroupExptd, ...
        secondGroupExptd] = readAndPrepareFile(imageFiles(i), setFolder);
    
    % Primeira fase de extra��o - extra��o grosseira do c�digo de barras
    [extractedBarCode1SD, boundingBox1SD] = ...
        barCodeExtractionPhase1(image, false);
    
    % Recorta c�digo de barras da imagem original
    [extractedBarCode1HD, boundingBox1HD] = getFullSizeBarCode(...
        originalImage, scale, boundingBox1SD);
          
    % Segunda fase de extra��o - refina extra��o do c�digo de barras
    [extractedBarCode2HD, boundingBox2] = barCodeExtractionPhase2(...
        extractedBarCode1HD, boundingBox1HD, false);
    
    if showResultImages
        figure;
        subplot(221); imshow(originalImage);
        hold on;
        rectangle('Position', boundingBox1HD, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
        title('Original');
        
        subplot(222); imshow(extractedBarCode1SD);
        title('C�digo de barras detectado SD');
        
        subplot(223); imshow(extractedBarCode1HD);
        hold on;
        rectangle('Position', boundingBox2, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
        title('C�digo de barras detectado HD - segunda fase');
        
        subplot(224);
        imshow(extractedBarCode2HD);
        title('C�digo de barras detectado refinado');
    end
end