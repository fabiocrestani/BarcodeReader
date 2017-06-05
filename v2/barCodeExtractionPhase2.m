function [extractedBarCode2, boundingBox2] = ... 
    barCodeExtractionPhase2(input, extractedBarCode1, boundingBox1, debug)
% Encontra o inicio e fim exatos do código de barras

    % Determina início do código de barras
    [m, n] = size(extractedBarCode1);
    inicioDoCodigoDeBarras = 0;
    for j = 1 : n
        %coluna = extractedBarCode1(1 : round(m/2), j);
        c = (mean(extractedBarCode1(1 : round(m/2), j))) < 250;
        if c == 1
            inicioDoCodigoDeBarras = j;
            break;
        end
    end
    
    % Determina fim do código de barras
    fimDoCodigoDeBarras = n;
    for j = n : -1 : 1
        %coluna = extractedBarCode1(1 : round(m/2), j);
        c = (mean(extractedBarCode1(1 : round(m/2), j))) < 250;
        if c == 1
            fimDoCodigoDeBarras = j;
            break;
        end
    end
    
    % Resultado
    boundingBox2 = boundingBox1;
    boundingBox2(1) = boundingBox2(1) + inicioDoCodigoDeBarras - 1;
    boundingBox2(3) = fimDoCodigoDeBarras - inicioDoCodigoDeBarras + 1;
    extractedBarCode2 = imcrop(input, boundingBox2);
    
    if debug
        figure; imshow(input); 
        hold on;
        rectangle('Position', boundingBox1, 'Linewidth', 1, ...
            'EdgeColor', 'y');
        rectangle('Position', boundingBox2, 'Linewidth', 1, ...
            'EdgeColor', 'g');
        hold off;
    end

end