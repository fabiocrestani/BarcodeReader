function [primeiroGrupo, segundoGrupo] = splitDigits(extracted, debug)

    if debug
        imshow(extracted);
        hold on;
    end

    [barCodeHeight, barCodeWidth] = size(extracted);
    digitWidth = barCodeWidth / 13.9;
    digitHeight = barCodeHeight / 2;
    
    % Primeiro grupo de dígitos (esquerda)
    % TODO
    primeiroGrupo = 0;
    

    % Segundo grupo de dígitos (direita)
    for j = 1 : 6
        region = [((barCodeWidth/2.2) + j*digitWidth) (digitHeight/2) ...
            digitWidth digitHeight];
        segundoGrupo{j} = imcrop(extracted, region);
        if debug
            rectangle('Position', region, 'Linewidth', 1, ...
                'EdgeColor', 'g');
        end
    end
    
    if debug
        hold off;
        figure; 
        for j = 1 : 6
            subplot(2, 3, j); 
            imshow(segundoGrupo{j}); 
            title(sprintf('Grupo 2\nDígito %d', j));
        end
    end

end