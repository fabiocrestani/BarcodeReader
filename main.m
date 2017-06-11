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
miniOCR = load('miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = 'imageSets/set3-cropped-random';
%setFolder = 'imageSets/set2-fotos';
imageFiles = dir([setFolder '/*.png']);
if length(imageFiles) < 1
    error('Erro: main. Nenhum arquivo encontrado');
end
numberOfFiles = length(imageFiles);

% Sele��o das fun��es
deteccao         = false;   % Encontra c�digo de barras na foto
decodificacao    = true;    % Decodifica c�digo de barras j� encontrado
showResultImages = false;   % true se quiser mostrar as imagens resultantes

% Para compara��o
acertos = 0;

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
    
    % Decodifica��o
    if decodificacao
        % Terceira fase de extra��o - extrai primeiro d�gito
        if deteccao
            firstDigitExtracted = ...
                getFirstDigitFromDetection(extractedBarCode2, false);
        else
            [firstDigitExtracted, boundingBox3] = ...
                barCodeExtractionPhase3(image, extractedBarCode2, ...
                boundingBox2, false);
        end

        % Identifica primeiro d�gito
        firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR);

        % Cropa c�digo de barras novamente
        [m, n] = size(extractedBarCode2);
        croppedBarCode = imcrop(extractedBarCode2, ...
                                    [1, (m/3), n, m - 2*(m/3)]);
        % 
        if deteccao
            croppedBarCode = imresize(croppedBarCode, [58 190]);
            %croppedBarCode = im2bw(croppedBarCode, ...
            %    graythresh(croppedBarCode));
            croppedBarCode = imadjust(croppedBarCode);
    
            [Gx, Gy] = imgradientxy(image);
            [Gmag, Gdir] = imgradient(Gx, Gy);
            
            % M�dia por coluna
            %GdirMean = mean(Gdir, 1);
            %angle = mean(Gdir(:)) / 2;
            %rotated = imrotate(extractedBarCode2, angle, 'bilinear', 'crop');
            %figure;
            %subplot(121); imshow(extractedBarCode2);
            %subplot(122); imshow(rotated);
            %figure; imshowpair(extractedBarCode2, rotated);
            %extractedBarCode2 = rotated;
        end
        
        % Determina primeiro e segundo grupo do c�digo de barras
        [barWidths, firstGroup, secondGroup] = ...
            splitGroups(croppedBarCode, false);

        % Divide cada grupo em 6 d�gitos
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
        fprintf('Arquivo:   %d de %d\n', i, numberOfFiles);
        fprintf('Esperado:  %s-%s-%s\n', firstDigitExptd, ...
            firstGroupExptd, secondGroupExptd);
        fprintf('Obtido:    %s-%s-%s\n', int2str(firstDigit), ...
            firstGroupString, secondGroupString);
        if strcmp(firstDigitExptd, int2str(firstDigit)) && ...
            strcmp(firstGroupExptd, firstGroupString) && ...
            strcmp(secondGroupExptd, secondGroupString)        
            fprintf('Resultado: OK\n');
            acertos = acertos + 1;
        else
            fprintf('Resultado: N�o OK\n');
        end
        if isCRCCorrect
            fprintf('CRC:       OK\n\n');
        else 
            fprintf('CRC:       N�o OK\n\n');
        end
    end
    
    if showResultImages
        if decodificacao
            figure; imshow(extractedBarCode1); 
            title('1a fase da extra��o');
            figure; imshow(extractedBarCode2); 
            title('2a fase da extra��o');
            figure; imshow(firstDigitExtracted); 
            title('3a fase da extra��o'); 
            xlabel(firstDigit);
            figure;
            subplot(311); stem(barWidths); title('barWidths'); grid;
            subplot(312); stem(firstGroup); title('firstGroup'); grid;
            subplot(313); stem(secondGroup); title('secondGroup'); grid;
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

erros = numberOfFiles - acertos;
acertos = 100 * acertos / numberOfFiles;
erros = 100 * erros / numberOfFiles;
fprintf('Acertos:   %.1f%% \nErros:     %.1f%%\n\n', acertos, erros);
