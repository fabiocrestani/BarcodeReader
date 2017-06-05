%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Universidade Tecnológica Federal do Paraná                             %
% Curitiba, PR                                                           %
% Engenharia Eletrônica                                                  %
% Processamento Digital de Imagens                                       %
%                                                                        %
% Projeto final da disciplina                                            %
% Leitor de códigos de barras EAN-13                                     %
% https://pt.wikipedia.org/wiki/EAN-13                                   %
%                                                                        %
% Autor: Fábio Crestani                                                  %
% Email: crestani.fabio@gmail.com                                        %
% GitHub: https://github.com/fabiocrestani                               %
%                                                                        %
% Versão 0.2.0                                                           %
% 05/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Carrega miniOCR
miniOCR = load('../miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = '../set1';
imageFiles = dir([setFolder '/*.png']);      
numerOfFiles = length(imageFiles);
numerOfFiles = 1;
for i = 1 : numerOfFiles
    currentFileName = imageFiles(i).name;
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
    
    % Primeira fase de extração - extração grosseira do código de barras
    [extractedBarCode1, boundingBox1] = ...
        barCodeExtractionPhase1(image, false);
    
    % Segunda fase de extração - refina extração do código de barras
    [extractedBarCode2, boundingBox2] = barCodeExtractionPhase2(image, ...
        extractedBarCode1, boundingBox1, false);
   
    % Terceira fase de extração - extrai primeiro dígito
    [firstDigitExtracted, boundingBox3] = barCodeExtractionPhase3(...
        image, extractedBarCode2, boundingBox2, false);
    
    % Identifica primeiro dígito
    firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR);
    
    % Determina primeiro e segundo grupo do código de barras
    [barWidths, firstGroup, secondGroup] = ...
        splitGroups(extractedBarCode2, false);
    
    
    % Resultados
    %figure; imshow(extractedBarCode1); title('1a fase da extração');
    %figure; imshow(extractedBarCode2); title('2a fase da extração');
    %figure; imshow(firstDigitExtracted); title('3a fase da extração'); xlabel(firstDigit);
       
    figure;
    subplot(311); stem(barWidths); title('barWidths'); grid;
    subplot(312); stem(firstGroup); title('firstGroup'); grid;
    subplot(313); stem(secondGroup); title('secondGroup'); grid;
    
    % TODO percorre segundo grupo e pega bits
    
end