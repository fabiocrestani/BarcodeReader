function [extractedBarCode2, boundingBox2, firstDigit] = ... 
    barCodeExtractionPhase2(input, extractedBarCode1, boundingBox1, debug)
% Encontra o inicio e fim exatos do código de barras

    % Determina início do código de barras
    [m, n] = size(extractedBarCode1);
    extractedBarCode1 = im2bw(extractedBarCode1, ...
        graythresh(extractedBarCode1));
    LEFT_MARGIN = 10;
    box = [LEFT_MARGIN 3*m/10 n-LEFT_MARGIN (m - 9*m/10)];
    extractedBarCode1 = imcrop(extractedBarCode1, box);
    
    inicioDoCodigoDeBarras = 0;
    for j = 1 : n-LEFT_MARGIN
        c = (mean(extractedBarCode1(:, j))) < 1;
        if c == 1
            inicioDoCodigoDeBarras = j;
            break;
        end
    end
    
    % Determina fim do código de barras
    fimDoCodigoDeBarras = n;
    for j = n-LEFT_MARGIN : -1 : 1
        c = (mean(extractedBarCode1(:, j))) < 0.5;
        if c == 1
            fimDoCodigoDeBarras = j;
            break;
        end
    end
    
    % Pega primeiro dígito
    fDSize = m/8;
    boundingBoxFirstDigit = [1 (m - fDSize) fDSize fDSize];
    firstDigit = imcrop(input, boundingBoxFirstDigit);
    if debug
        figure; imshow(input);
        rectangle('Position', boundingBoxFirstDigit, 'Linewidth', 1, ...
            'EdgeColor', 'y');
        title('Localização do primeiro dígito');
    end
    
    % Resultado
    boundingBox2 = boundingBox1;
    boundingBox2(1) = boundingBox2(1) + inicioDoCodigoDeBarras - 1;
    boundingBox2(3) = fimDoCodigoDeBarras - inicioDoCodigoDeBarras + 1;
    extractedBarCode2 = imcrop(input, boundingBox2);
    
    if debug
        figure; imshow(extractedBarCode1); 
        hold on;
        rectangle('Position', boundingBox1, 'Linewidth', 1, ...
            'EdgeColor', 'y');
        rectangle('Position', boundingBox2, 'Linewidth', 1, ...
            'EdgeColor', 'g');
        title('Determina início e final exatos do código de barras');
        hold off;
    end

end