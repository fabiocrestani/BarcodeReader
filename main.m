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
% 11/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Carrega miniOCR
miniOCR = load('miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = 'imageSets/set5-fotos-hd';
format = 'jpg';
imageFiles = dir([setFolder '/*.' format]);
if length(imageFiles) < 1
    error('Erro: main. Nenhum arquivo encontrado');
end
numberOfFiles = length(imageFiles);
numberOfFiles = 1;

% Seleção das funções
showResultImages       = false;
bypassFirstDigitDecode = true;

% Para comparação
acertos = 0;

for i = 1 : numberOfFiles
    
    % Lê arquivo e pré-processa
    [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
        readAndPrepareFile(imageFiles(i), setFolder);
    
    % Endireita código de barras
    extractedBarCode1Rotate = rotateBarCode(image, false);
    
    % Segunda fase de extração - refina extração do código de barras
    [m, n] = size(extractedBarCode1Rotate);
    boundingBox1 = [1 1 n m];
    [extractedBarCode2, boundingBox2, firstDigitExtracted] = ...
        barCodeExtractionPhase2(image, extractedBarCode1Rotate, ...
        boundingBox1, false);
    
    % Redimensiona
    extractedBarCode2 = imresize(extractedBarCode2, [2*171 2*191]);
    
    % Identifica primeiro dígito
    firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR, ...
        firstDigitExptd, bypassFirstDigitDecode);

    % Cropa código de barras novamente
    [m, n] = size(extractedBarCode2);
    croppedBarCode = imcrop(extractedBarCode2, ...
                                 [1, (3*m/12), n, m - 11*(m/12)]);
 
    % Determina primeiro e segundo grupo do código de barras
    [barWidths, firstGroup, secondGroup] = ...
         splitGroups(croppedBarCode, true);

    % Divide cada grupo em 6 dígitos
    firstGroupDigits = splitGroupDigits(firstGroup);
    secondGroupDigits = splitGroupDigits(secondGroup);

    % Decodifica grupo
    [firstGroupInteger, firstGroupString] = decodeGroup(...
        firstGroupDigits, firstDigit);
    [secondGroupInteger, secondGroupString] = decodeGroup(...
        secondGroupDigits);

    % Calcula CRC
    [isCRCCorrect, computedCRC] = calculateCRC(firstDigit, ...
        firstGroupString, secondGroupString);   

    % Resultados
    fprintf('Arquivo:         %d de %d\n', i, numberOfFiles);
    fprintf('Esperado:        %s-%s-%s\n', firstDigitExptd, ...
        firstGroupExptd, secondGroupExptd);
    fprintf('Obtido:          %s-%s-%s\n', int2str(firstDigit), ...
        firstGroupString, secondGroupString);
    fprintf('Dígitos errados: %d\n', countNumberOfWrongDigits(...
        firstGroupString, secondGroupString, firstGroupExptd, ...
        secondGroupExptd));
    if strcmp(firstDigitExptd, int2str(firstDigit)) && ...
        strcmp(firstGroupExptd, firstGroupString) && ...
        strcmp(secondGroupExptd, secondGroupString)        
        fprintf('Resultado:       OK\n');
        acertos = acertos + 1;
    else
        fprintf('Resultado:       Não OK\n');
    end
    if isCRCCorrect
        fprintf('CRC:             OK\n\n');
    else 
        fprintf('CRC:             Não OK\n\n');
    end
    
    if showResultImages
        figure; 
        subplot(221); imshow(extractedBarCode1Rotate);
        title('Primeira fase da extração'); 
        xlabel(['Arquivo: ' num2str(i)]);
        subplot(222); imshow(extractedBarCode2); 
        title('Segunda fase da extração');
        subplot(223); imshow(firstDigitExtracted); 
        title(['Primeiro dígito = ' num2str(firstDigit)]);
        subplot(224); imshow(croppedBarCode);
        title('Região a ser decodificada');
    end
end

erros = numberOfFiles - acertos;
acertos = 100 * acertos / numberOfFiles;
erros = 100 * erros / numberOfFiles;
fprintf('Acertos:           %.1f%% \nErros:           %.1f%%\n\n', ...
    acertos, erros);
