function [extractedBarCode2, boundingBox2] = ... 
    barCodeExtractionPhase2(extractedBarCode, boundingBox, debug)
% Encontra o inicio e fim exatos do código de barras

    % Guarda input
    input = extractedBarCode;

    % Trata caso onde imagem de entrada é colorida
    extractedBarCode = convertIfColorImage(extractedBarCode);

    % Determina início do código de barras
    [m, n] = size(extractedBarCode);
    extractedBarCode = im2bw(extractedBarCode, 0.4);
    extractedBarCode = imboxfilt(extractedBarCode, 11);
    
    inicioDoCodigoDeBarras = 0;
    for j = 1 : n
        c = (mean(extractedBarCode(1 : round(m/5), j))) < 1;
        if c == 1
            inicioDoCodigoDeBarras = j;
            break;
        end
    end
    
    % Determina fim do código de barras
    fimDoCodigoDeBarras = n;
    for j = n : -1 : 1
        c = (mean(extractedBarCode(1 : round(m/5), j))) < 1;
        if c == 1
            fimDoCodigoDeBarras = j;
            break;
        end
    end
    
    % Resultado
    [m, n] = size(extractedBarCode);
    boundingBox2 = [1 1 n m];
    boundingBox2(1) = boundingBox2(1) + inicioDoCodigoDeBarras - 1;
    boundingBox2(3) = fimDoCodigoDeBarras - inicioDoCodigoDeBarras + 1;
    extractedBarCode2 = imcrop(input, boundingBox2);
    
    if debug
        figure; imshow(extractedBarCode); 
        hold on;
        rectangle('Position', boundingBox, 'Linewidth', 1, ...
            'EdgeColor', 'y');
        rectangle('Position', boundingBox2, 'Linewidth', 1, ...
            'EdgeColor', 'g');
        title('Determina início e final exatos do código de barras');
        hold off;
        
        figure; imshow(extractedBarCode);
    end

end