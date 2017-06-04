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
% Vers�o 0.1                                                             %
% 30/05/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

setFolder = 'set1';
imageFiles = dir([setFolder '/*.png']);      
numerOfFiles = length(imageFiles);
numerOfFiles = 1;
for i = 1 : numerOfFiles
    currentFileName = imageFiles(i).name;
    disp(currentFileName);
    image = imread([setFolder '/' currentFileName]);
    image = mat2gray(image);
    imshow(image);
   
    % Pega o c�digo esperado atrav�s do nome do arquivo
    [inputLegend, primeiroGrupoEsperado, segundoGrupoEsperado, ~] = ...
        buildLegendFromFileName(currentFileName);
    
    % Extrai o c�digo de barras da imagem
    [firstDigitExtracted, extracted] = extractBarCode(image, false);
    figure; 
    subplot(121); imshow(firstDigitExtracted); xlabel('Primeiro d�gito');
    subplot(122); imshow(extracted); xlabel(inputLegend);
        
    % Separa os d�gitos
    [codeId, primeiroGrupo, segundoGrupo] = splitDigits(extracted, false);
    
    codeId
    
    % Para cada d�gito, separa os bits e determina o n�mero correspondente
    primeiroGrupoEncontrado = '';
    segundoGrupoEncontrado = '';
    for j = 1 : 6
%         digits = getDigitBits(primeiroGrupo{j}, false);
%         number = translateBarCodeCodification(digits, 'r');
%         primeiroGrupoEncontrado = ...
%             strcat(primeiroGrupoEncontrado, int2str(number));
        
        digits = getDigitBits(segundoGrupo{j}, false);
        number = translateBarCodeCodification(digits, 'r');
        segundoGrupoEncontrado = ...
            strcat(segundoGrupoEncontrado, int2str(number));
    end
    
    % Resultado
    fprintf('Esperado: %s Encontrado %s ', segundoGrupoEsperado, ...
        segundoGrupoEncontrado);
    if segundoGrupoEsperado == segundoGrupoEncontrado
        fprintf(' OK!\n' );
    else 
        fprintf(' Errou.\n' );
    end
    
end