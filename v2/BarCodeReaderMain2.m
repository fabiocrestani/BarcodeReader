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
%                                                                        %
% Vers�o 0.2.0                                                           %
% 30/05/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

setFolder = '../set0';
imageFiles = dir([setFolder '/*.png']);      
numerOfFiles = length(imageFiles);
numerOfFiles = 1;
for i = 1 : numerOfFiles
    currentFileName = imageFiles(i).name;
    image = imread([setFolder '/' currentFileName]);
    [~, ~, channelNumber] = size(image);
    if channelNumber == 3
        image = rgb2gray(image);
    end
    image = mat2gray(image);
    
    % Primeira fase de extra��o
    extractedBarCode1 = barCodeExtractionPhase1(image, false);
    
    % Segunda fase de extra��o
    
    % TODO recortar quando encontrar a primeira coluna de 1s, da esquerda
    % para a direita
    
end