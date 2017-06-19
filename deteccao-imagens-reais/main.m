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
% Branch: deteccao-imagens-reais                                         %
% Versão 1.0.0                                                           %
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

% Seleção das funções
deteccao         = true;    % Encontra código de barras na foto
showResultImages = false;    % true se quiser mostrar as imagens resultantes

% Para comparação
acertos = 0;
erros = 0;

for i = 1 : numberOfFiles
    
    % Lê arquivo e pré-processa
    [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
        readAndPrepareFile(imageFiles(i), setFolder);
    
    % Primeira fase de extração - extração grosseira do código de barras
    [extractedBarCode1, boundingBox1] = ...
        barCodeExtractionPhase1(image, false);
    
    % Segunda fase de extração - refina extração do código de barras
    [extractedBarCode2, boundingBox2] = barCodeExtractionPhase2(image, ...
        extractedBarCode1, boundingBox1, false);
    
    % Redimensiona
    extractedBarCode2 = imresize(extractedBarCode2, [171 191]);
    
    if showResultImages
        if decodificacao
            figure; imshow(extractedBarCode1); 
            title('1a fase da extração');
            figure; imshow(extractedBarCode2); 
            title('2a fase da extração');
            figure; imshow(firstDigitExtracted); 
            title('3a fase da extração'); 
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
