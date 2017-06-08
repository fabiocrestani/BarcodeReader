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
% Vers�o 0.2.1                                                           %
% 07/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Carrega miniOCR
miniOCR = load('../miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = '../imageSets/set3-cropped-random';
%setFolder = '../imageSets/set0';
imageFiles = dir([setFolder '/*.png']);      
numberOfFiles = length(imageFiles);
%numberOfFiles = 1;

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
   
    % Terceira fase de extra��o - extrai primeiro d�gito
    [firstDigitExtracted, boundingBox3] = barCodeExtractionPhase3(...
        image, extractedBarCode2, boundingBox2, false);
    
    % Identifica primeiro d�gito
    firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR);
    
    % Determina primeiro e segundo grupo do c�digo de barras
    [barWidths, firstGroup, secondGroup] = ...
        splitGroups(extractedBarCode2, false);
    
    % Divide cada grupo em 6 d�gitos
    firstGroupDigits = splitGroupDigits(firstGroup);
    secondGroupDigits = splitGroupDigits(secondGroup);
    
    % Decodifica grupo
    [firstGroupInteger, firstGroupString] = decodeGroup(...
        firstGroupDigits, firstDigit);
    [secondGroupInteger, secondGroupString] = decodeGroup(...
        secondGroupDigits);
    
    % Resultados
    debug = false;
    if debug
        figure; imshow(extractedBarCode1); title('1a fase da extra��o');
        figure; imshow(extractedBarCode2); title('2a fase da extra��o');
        figure; imshow(firstDigitExtracted); title('3a fase da extra��o'); 
        xlabel(firstDigit);
        figure;
        subplot(311); stem(barWidths); title('barWidths'); grid;
        subplot(312); stem(firstGroup); title('firstGroup'); grid;
        subplot(313); stem(secondGroup); title('secondGroup'); grid;
    end
    
    fprintf('Esperado:  %s-%s-%s\n', firstDigitExptd, firstGroupExptd, ...
        secondGroupExptd);
    fprintf('Obtido:    %s-%s-%s\n', int2str(firstDigit), ...
        firstGroupString, secondGroupString);

    if strcmp(firstDigitExptd, int2str(firstDigit)) && ...
        strcmp(firstGroupExptd, firstGroupString) && ...
        strcmp(secondGroupExptd, secondGroupString)        
        fprintf('Resultado: OK\n\n');
        acertos = acertos + 1;
    else
        fprintf('Resultado: N�o OK\n\n');
        erros = erros + 1;
    end
end

acertos = 100 * acertos / numberOfFiles;
erros = 100 * erros / numberOfFiles;
fprintf('Acertos:   %.1f%% \nErros:     %.1f%%\n\n', acertos, erros);
