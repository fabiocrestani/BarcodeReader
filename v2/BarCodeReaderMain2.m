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
% Versão 0.2.1                                                           %
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
   
    % Terceira fase de extração - extrai primeiro dígito
    [firstDigitExtracted, boundingBox3] = barCodeExtractionPhase3(...
        image, extractedBarCode2, boundingBox2, false);
    
    % Identifica primeiro dígito
    firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR);
    
    % Determina primeiro e segundo grupo do código de barras
    [barWidths, firstGroup, secondGroup] = ...
        splitGroups(extractedBarCode2, false);
    
    % Divide cada grupo em 6 dígitos
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
        figure; imshow(extractedBarCode1); title('1a fase da extração');
        figure; imshow(extractedBarCode2); title('2a fase da extração');
        figure; imshow(firstDigitExtracted); title('3a fase da extração'); 
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
        fprintf('Resultado: Não OK\n\n');
        erros = erros + 1;
    end
end

acertos = 100 * acertos / numberOfFiles;
erros = 100 * erros / numberOfFiles;
fprintf('Acertos:   %.1f%% \nErros:     %.1f%%\n\n', acertos, erros);
