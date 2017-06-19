function [barWidths] = splitGroupBits(g, debug)
% Percorre g da esquerda para a direita e determinar barWidhts

    previous = g(1);
    barNumber = 0;
    barWidth = 1;
    for k = 2 : length(g)
        if g(k) ~= previous
            previous = g(k);
            barNumber = barNumber + 1;
            if g(k) > 0
                barWidths(barNumber) = -barWidth;
            else
                barWidths(barNumber) = barWidth;
            end
            barWidth = 0;
        else
            barWidth = barWidth + 1;
        end
    end
    % Trata última barra
    if g(k) > 0
        barWidths(barNumber + 1) = barWidth;
    else
        barWidths(barNumber + 1) = -barWidth;
    end
        
    % Conta o número de barras
    barsAcum = 0;
    for k = 2 : length(barWidths)
        barsAcum(k) = barsAcum(k - 1) + abs(barWidths(k));
    end
    
    % Normaliza larguras e arredonda
    barWidths = 40 * barWidths / barsAcum(length(barsAcum));
    barWidths = round(barWidths);
    barWidths(barWidths > 4) = 4;
    
    if debug
        figure; subplot(211); 
        stem(barWidths, 'Marker', 'none', 'LineWidth', 3); grid;
        title('Antes');
        subplot(212); 
        stem(barWidths, 'Marker', 'none', 'LineWidth', 3); grid;
        title('Depois');
    end

end