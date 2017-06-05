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
% Vers�o 0.2.0                                                           %
% 04/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Carrega miniOCR
miniOCR = load('../miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = '../set0';
imageFiles = dir([setFolder '/*.png']);      
numerOfFiles = length(imageFiles);
%numerOfFiles = 10;
for i = 1 : numerOfFiles
    currentFileName = imageFiles(i).name;
    image = imread([setFolder '/' currentFileName]);
    
    % Trata caso onde imagem de entrada � colorida
    [~, ~, channelNumber] = size(image);
    if channelNumber == 3
        image = rgb2gray(image);
    end
    image = mat2gray(image);
    
    % Primeira fase de extra��o - extra��o grosseira do c�digo de barras
    [extractedBarCode1, boundingBox1] = ...
        barCodeExtractionPhase1(image, false);
    
    % Segunda fase de extra��o - refina extra��o do c�digo de barras
    [extractedBarCode2, boundingBox2] = barCodeExtractionPhase2(image, ...
        extractedBarCode1, boundingBox1, false);
   
    % Terceira fase de extra��o - extrai primeiro d�gito
    [firstDigitExtracted, boundingBox3] = barCodeExtractionPhase3(...
        image, extractedBarCode2, boundingBox2, false);
    
    % Identifica primeiro d�gito
    firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR);
    

    
    
    

    % Resultados
    figure; imshow(extractedBarCode1); title('1a fase da extra��o');
    figure; imshow(extractedBarCode2); title('2a fase da extra��o');
    figure; imshow(firstDigitExtracted); title('3a fase da extra��o');
    xlabel(firstDigit);
    
    
end