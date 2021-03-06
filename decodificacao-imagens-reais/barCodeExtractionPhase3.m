function [firstDigitExtracted, boundingBox3] = ...
    barCodeExtractionPhase3(image, extractedBarCode2, boundingBox2, debug)
% Extrai o primeiro d�gito do c�digo de barras

    [m, n] = size(extractedBarCode2);
    
    firstDigitWidth = n*0.11;
    firstDigitHeight = m*0.11;
    
    boundingBox3 = boundingBox2;
    boundingBox3(1) = boundingBox3(1) - firstDigitWidth + 1;
    boundingBox3(2) = boundingBox3(2) + boundingBox3(4) - firstDigitHeight;
    boundingBox3(3) = firstDigitWidth / 2;
    boundingBox3(4) = firstDigitHeight - 1;
    
    if debug
        figure; 
        imshow(image); 
        hold on;
        rectangle('Position', boundingBox3, 'Linewidth', 1, ...
            'EdgeColor', 'g');
        hold off;
        title('Primeiro d�gito localizado');
    end
    
    firstDigitExtracted = imcrop(image, boundingBox3);
end