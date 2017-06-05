function [firstDigitExtracted, barCodeExtracted] = ...
    extractBarCodeLevel2(input, debug)
% Encontra e extrai um c�digo de barras de uma imagem

    inputImage = mat2gray(input);

    [m n] = size(input);

    inicioDoCodigoDeBarras = 0;
    
    % TODO
    
    % Encontra o in�cio do c�digo de barras
    for i = 1 : m
        coluna = mean(input(1 : (n/2), i)) > 0.5;
        if coluna == 1
            inicioDoCodigoDeBarras = i;
            break;
       end
 %      pause;
    end
    
    inicioDoCodigoDeBarras
    
    
    firstDigitExtracted = 0;
    barCodeExtracted = 0;

end