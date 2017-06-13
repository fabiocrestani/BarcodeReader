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
    %barWidths = 100 * barWidths / barsAcum(length(barsAcum) - 1);
    
    if debug
        figure; subplot(211); 
        stem(barWidths, 'Marker', 'none', 'LineWidth', 3); grid;
        title('Antes');
    end
    
    for k = 1 : length(barWidths)
        absBar = abs(barWidths(k));
        positiveBar = barWidths(k) > 0;
        if absBar < 0.01, absBar = 0; end
        if absBar < 4.5 && absBar >= 0.01, absBar = 1; end;
        if absBar < 8.5 && absBar >= 4.5, absBar = 2; end;
        if absBar < 15 && absBar >= 8.5, absBar = 3; end;
        if absBar >= 15, absBar = 4; end;   
        if positiveBar
            barWidths(k) = absBar;
        else
            barWidths(k) = -absBar;
        end
    end
    barWidths(barWidths==0)=[]; 
    
    if debug
        subplot(212); 
        stem(barWidths, 'Marker', 'none', 'LineWidth', 3); grid;
        title('Depois');
    end

end