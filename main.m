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
miniOCR = load('miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = 'imageSets/set4-fotos-cropped';
imageFiles = dir([setFolder '/*.png']);
if length(imageFiles) < 1
    error('Erro: main. Nenhum arquivo encontrado');
end
numberOfFiles = length(imageFiles);

% Seleção das funções
showResultImages = true;   % true se quiser mostrar as imagens resultantes

% Para comparação
acertos = 0;

for i = 8 : 8 
    
    % Lê arquivo e pré-processa
    [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
        readAndPrepareFile(imageFiles(i), setFolder);
    
    % Primeira fase de extração - extração grosseira do código de barras
    [extractedBarCode1, boundingBox1] = ...
        barCodeExtractionPhase1(image, false, 15);
    
    % Endireita código de barras
    %extractedBarCode1Rotate = rotateBarCode(extractedBarCode1, false);
    extractedBarCode1Rotate = extractedBarCode1;
    

    
    %[extractedBarCode2, boundingBox2] = ...
     %  barCodeExtractionPhase1(extractedBarCode1, true, 32);
    
    % Segunda fase de extração - refina extração do código de barras
    %[extractedBarCode2, boundingBox2] = barCodeExtractionPhase2(image, ...
    %     extractedBarCode1, boundingBox1, false);
    
    % Redimensiona
%     extractedBarCode2 = imresize(extractedBarCode2, [171 191]);
    
    % Decodificação
    % Terceira fase de extração - extrai primeiro dígito
%     firstDigitExtracted = ...
%         getFirstDigitFromDetection(extractedBarCode2, false);


    % Identifica primeiro dígito
%     firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR);

    % Cropa código de barras novamente
%     [m, n] = size(extractedBarCode2);
%     croppedBarCode = imcrop(extractedBarCode2, ...
%                                 [1, (m/3), n, m - 2*(m/3)]);
    % 
%     croppedBarCode = imresize(croppedBarCode, [58 190]);
%     %croppedBarCode = im2bw(croppedBarCode, ...
%     %    graythresh(croppedBarCode));
%     croppedBarCode = imadjust(croppedBarCode);
%     [Gx, Gy] = imgradientxy(image);
%     [Gmag, Gdir] = imgradient(Gx, Gy);

    % Determina primeiro e segundo grupo do código de barras
%     [barWidths, firstGroup, secondGroup] = ...
%         splitGroups(croppedBarCode, false);

    % Divide cada grupo em 6 dígitos
%     firstGroupDigits = splitGroupDigits(firstGroup);
%     secondGroupDigits = splitGroupDigits(secondGroup);

    % Decodifica grupo
%     [firstGroupInteger, firstGroupString] = decodeGroup(...
%         firstGroupDigits, firstDigit);
%     [secondGroupInteger, secondGroupString] = decodeGroup(...
%         secondGroupDigits);

    % Calcula CRC
%     [isCRCCorrect, computedCRC] = calculateCRC(firstDigit, ...
%         firstGroupString, secondGroupString);   

    % Resultados
%     fprintf('Arquivo:   %d de %d\n', i, numberOfFiles);
%     fprintf('Esperado:  %s-%s-%s\n', firstDigitExptd, ...
%         firstGroupExptd, secondGroupExptd);
%     fprintf('Obtido:    %s-%s-%s\n', int2str(firstDigit), ...
%         firstGroupString, secondGroupString);
%     if strcmp(firstDigitExptd, int2str(firstDigit)) && ...
%         strcmp(firstGroupExptd, firstGroupString) && ...
%         strcmp(secondGroupExptd, secondGroupString)        
%         fprintf('Resultado: OK\n');
%         acertos = acertos + 1;
%     else
%         fprintf('Resultado: Não OK\n');
%     end
%     if isCRCCorrect
%         fprintf('CRC:       OK\n\n');
%     else 
%         fprintf('CRC:       Não OK\n\n');
%     end
    
    if showResultImages
        figure; imshow(image); title('Primeira fase');
        hold on; rectangle('Position', boundingBox1, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
        figure; imshow(extractedBarCode1Rotate); title('extractedBarCode1Rotate');
    end
end

erros = numberOfFiles - acertos;
acertos = 100 * acertos / numberOfFiles;
erros = 100 * erros / numberOfFiles;
fprintf('Acertos:   %.1f%% \nErros:     %.1f%%\n\n', acertos, erros);
