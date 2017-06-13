function [firstDigitExtracted] = getFirstDigitFromDetection(...
    input, debug)

    [m, n] = size(input);
    
    firstDigitWidth = n*0.15;
    firstDigitHeight = m*0.17;
    
    boundingBox3 = [1 1 n m];
    boundingBox3(2) = boundingBox3(2) + boundingBox3(4) - firstDigitHeight;
    boundingBox3(3) = firstDigitWidth / 2;
    boundingBox3(4) = firstDigitHeight - 1;
    
    if debug
        figure; 
        imshow(input); 
        hold on;
        rectangle('Position', boundingBox3, 'Linewidth', 1, ...
            'EdgeColor', 'g');
        hold off;
        title('Primeiro dígito localizado');
    end
    
    firstDigitExtracted = imcrop(input, boundingBox3);

end