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
setFolder = '../imageSets/set6-fotos-hd-full';
fileType = 'jpg';
imageFiles = dir([setFolder '/*.' fileType]);
if length(imageFiles) < 1
    error('Erro: main. Nenhum arquivo encontrado');
end
numberOfFiles = length(imageFiles);

% Sele��o das fun��es
deteccao         = true;    % Encontra c�digo de barras na foto
showResultImages = false;    % true se quiser mostrar as imagens resultantes

% Para compara��o
acertos = 0;
erros = 0;

for i = 1 : numberOfFiles
    
    % L� arquivo e pr�-processa
    [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
        readAndPrepareFile(imageFiles(i), setFolder);
    
    % Primeira fase de extra��o - extra��o grosseira do c�digo de barras
    [extractedBarCode1, boundingBox1] = ...
        barCodeExtractionPhase1(image, false);
    
    % Segunda fase de extra��o - refina extra��o do c�digo de barras
    [extractedBarCode2, boundingBox2] = barCodeExtractionPhase2(image, ...
        extractedBarCode1, boundingBox1, false);
    
    % Redimensiona
    extractedBarCode2 = imresize(extractedBarCode2, [171 191]);
    
    if showResultImages
        if decodificacao
            figure; imshow(extractedBarCode1); 
            title('1a fase da extra��o');
            figure; imshow(extractedBarCode2); 
            title('2a fase da extra��o');
            figure; imshow(firstDigitExtracted); 
            title('3a fase da extra��o'); 
            xlabel(firstDigit);
        else
            figure;
            subplot(121); imshow(image);
            hold on;
            rectangle('Position', boundingBox1, 'Linewidth', 2, ...
                'EdgeColor', 'g');
            hold off;
            subplot(122); imshow(extractedBarCode2);
        end
    end
end
