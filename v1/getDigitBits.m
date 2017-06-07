function [bits] = getDigitBits(input, debug)
% Retorna os 7 bits de um dígito do código de barras

    if debug
        figure;
        imshow(input);
        hold on;
    end

    [digitHeight, digitWidth] = size(input);
    bitWidth = digitWidth/7;
    bits = zeros(1, 7);
    for j = 1 : 7
        region = [0.5+(j-1)*bitWidth 1 bitWidth digitHeight];
        digitBar = imcrop(input, region);
        bits(j) = mean(digitBar(:));
        digitBars{j} = digitBar;

        if debug
            rectangle('Position', region, 'Linewidth', 1, 'EdgeColor', 'g');
        end
    end
    
    % Limiaria em dois níveis
    bits = bits < (255/2);
    
    if debug
        hold off;
        figure; 
        for j = 1 : 7
            subplot(2, 4, j); 
            imshow(digitBars{j}); 
            if bits(j)
                xlabel('1');
            else
                xlabel('0');
            end
        end
    end

end