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
% Branch: decodificacao-imagens-reais                                    %
% Vers�o 1.0.0                                                           %
% 19/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

% Carrega miniOCR
miniOCR = load('../miniOCR/miniOCR.mat');
miniOCR = miniOCR.miniOCR;

% Carrega imagens
setFolder = '../imageSets/set2-decodificacao-imagens-reais';
fileType = 'jpg';
imageFiles = dir([setFolder '/*.' fileType]);
if length(imageFiles) < 1
    error('Erro: main. Nenhum arquivo encontrado');
end
numberOfFiles = length(imageFiles);

% Sele��o das fun��es
showResultImages       = false;
bypassFirstDigitDecode = true;

% Para compara��o
acertos = 0;
digitosErrados = zeros(1, numberOfFiles);

for i = 1 : numberOfFiles    

    % L� arquivo e pr�-processa
    [image, firstDigitExptd, firstGroupExptd, secondGroupExptd] = ...
        readAndPrepareFile(imageFiles(i), setFolder);
    
    % Endireita c�digo de barras
    extractedBarCode1Rotate = rotateBarCode(image, false);
    
    % Segunda fase de extra��o
    [m, n] = size(extractedBarCode1Rotate);
    boundingBox1 = [1 1 n m];
    [extractedBarCode2, boundingBox2, firstDigitExtracted] = ...
        barCodeExtractionPhase2(image, extractedBarCode1Rotate, ...
        boundingBox1, false);
    
    % Redimensiona
    extractedBarCode2 = imresize(extractedBarCode2, [2*171 2*191]);
    
    % Identifica primeiro d�gito
    firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR, ...
        firstDigitExptd, bypassFirstDigitDecode);
    
    [m, n] = size(extractedBarCode2);
    croppedBarCode = imcrop(extractedBarCode2, ...
                                 [1, (3*m/10), n, m - 9*(m/10)]);
 
    % Determina primeiro e segundo grupo do c�digo de barras    
    [g1, g2] = barCodeExtractGroups(croppedBarCode, false); 
    firstGroup  = splitGroupBits(g1, false);
    secondGroup = splitGroupBits(g2, false);
     
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
    fprintf('Arquivo:         %d de %d\n', i, numberOfFiles);
    fprintf('Esperado:        %s-%s-%s\n', firstDigitExptd, ...
        firstGroupExptd, secondGroupExptd);
    fprintf('Obtido:          %s-%s-%s\n', int2str(firstDigit), ...
        firstGroupString, secondGroupString);
    digitosErradosI = countNumberOfWrongDigits(...
        firstGroupString, secondGroupString, firstGroupExptd, ...
        secondGroupExptd);
    fprintf('D�gitos errados: %d\n', digitosErradosI);
    digitosErrados(i) = digitosErradosI;
    
    if strcmp(firstDigitExptd, int2str(firstDigit)) && ...
        strcmp(firstGroupExptd, firstGroupString) && ...
        strcmp(secondGroupExptd, secondGroupString)        
        fprintf('Resultado:       OK\n');
        acertos = acertos + 1;
    else
        fprintf('Resultado:       N�o OK\n');
    end
    if isCRCCorrect
        fprintf('CRC:             OK\n\n');
    else 
        fprintf('CRC:             N�o OK\n\n');
    end
    
    if showResultImages
        figure; 
        subplot(221); imshow(extractedBarCode1Rotate);
        title('Primeira fase da extra��o'); 
        xlabel(['Arquivo: ' num2str(i)]);
        subplot(222); imshow(extractedBarCode2); 
        title('Segunda fase da extra��o');
        subplot(223); imshow(firstDigitExtracted); 
        title(['Primeiro d�gito = ' num2str(firstDigit)]);
        subplot(224); imshow(croppedBarCode);
        title('Regi�o a ser decodificada');
    end
end

erros = numberOfFiles - acertos;
acertos = 100 * acertos / numberOfFiles;
erros = 100 * erros / numberOfFiles;
fprintf('Acertos:         %.1f%% \nErros:           %.1f%%\n', ...
    acertos, erros);
fprintf('M�dia de d�gitos errados: %.1f \n\n', mean(digitosErrados));
