function [barWidths, firstGroup, secondGroup] = ...
    decodeBarCode(croppedBarCode, debug)
% Decodifica o c�digo de barras

    croppedBarCode = imadjust(croppedBarCode, [], [], 2.5)*1.3;
    croppedBarCode = imsharpen(croppedBarCode);
    croppedBarCodeBeforeBW = croppedBarCode;
    %croppedBarCode = im2bw(croppedBarCode, graythresh(croppedBarCode));
    croppedBarCode = im2bw(croppedBarCode, 0.7);
    
    figure;  
    subplot(211); imshow([croppedBarCodeBeforeBW; 255*croppedBarCode]);    
    %croppedBarCode = imboxfilt(croppedBarCode, [7, 1]);
    subplot(212); imshow([croppedBarCodeBeforeBW; 255*croppedBarCode]);
    
    % Faz a m�dia por coluna
    GxMean = mean(croppedBarCode, 1);
    GxMean2 = GxMean;

    % Aplica dois thresholds
    threshold = 1/10;
    GxMean2(GxMean < threshold) = 0;
    GxMean2(GxMean > threshold) = 1;
    
    if debug
        figure;
        GxMean2Plot = [GxMean2; GxMean2; GxMean2; GxMean2; GxMean2;];
        GxMean2Plot = [GxMean2Plot; GxMean2Plot; GxMean2Plot; GxMean2Plot];
        subplot(221); imshow([croppedBarCodeBeforeBW; ...
            255*ones(5, length(croppedBarCodeBeforeBW)); ...
            255*croppedBarCode; ...
            255*ones(5, length(croppedBarCodeBeforeBW)); ...
            255*GxMean2Plot]); 
        title('extractedBarCode3');
        subplot(222); stem(GxMean, 'Marker', 'x', 'LineWidth', 1); 
        title('GxMean'); grid;
        t = 0:0.1:length(croppedBarCodeBeforeBW);
        hold on; 
        plot(t, ones(size(t))*threshold, 'r', 'LineWidth', 1);
        hold off;
        subplot(223); stem(GxMean2, 'Marker', 'none', 'LineWidth', 2); 
        title('GxMean2');
    end
    
    
    % Percorre GxMean2 da esquerda para a direita e determinar barWidhts
    previous = -1;
    barNumber = 0;
    barWidth = 1;
    for k = 2 : length(GxMean2)
        if GxMean2(k) ~= previous
            previous = GxMean2(k);
            barNumber = barNumber + 1;
            if GxMean2(k) > 0
                barWidths(barNumber) = -barWidth;
            else
                barWidths(barNumber) = barWidth;
            end
            barWidth = 0;
        else
            barWidth = barWidth + 1;
        end
    end
        
    % Remove primeira barra, se for branca
    if barWidths(1) > 0
        barWidths(1) = [];
    end
        
    % Conta o n�mero de barras
    barsAcum = 0;
    for k = 2 : length(barWidths)
        barsAcum(k) = barsAcum(k - 1) + abs(barWidths(k));
    end
    
    % Normaliza larguras e arredonda
    barWidths = 100 * barWidths / barsAcum(length(barsAcum) - 1);
    
    figure; subplot(211); 
    stem(barWidths, 'Marker', 'none', 'LineWidth', 3); grid;
    title('Antes');
    
    for k = 1 : length(barWidths)
        absBar = abs(barWidths(k));
        positiveBar = barWidths(k) > 0;
        if absBar < 0.01, absBar = 0; end
        if absBar < 1.7 && absBar >= 0.01, absBar = 1; end;
        if absBar < 2.7 && absBar >= 1.7, absBar = 2; end;
        if absBar < 3.7 && absBar >= 2.7, absBar = 3; end;
        if absBar >= 3.7, absBar = 4; end;   
        if positiveBar
            barWidths(k) = absBar;
        else
            barWidths(k) = -absBar;
        end
    end
    barWidths(barWidths==0)=[]; 
    
    subplot(212); 
    stem(barWidths, 'Marker', 'none', 'LineWidth', 3); grid;
    title('Depois');
    
    % Encontra marcadores
    mark = [-1 1 -1];
    events = [];
    for k = 1 : length(barWidths) - 2
        if barWidths(k : k+2) == mark
            events = [events k];
        end
    end
    
    events
    
    % Separa os dois grupos
    inicioG1 = 6;
    fimG1 = 29;
    inicioG2 = 35;
    fimG2 = 57;
    firstGroup = barWidths(inicioG1 : fimG1);
    secondGroup = barWidths(inicioG2 : fimG2);
    
    if debug
        figure;
        subplot(224); stem(barWidths, 'Marker', 'none', 'LineWidth', 3); 
        title('barWidths'); grid;
        xlabel(['Valor negativo: barra preta de tamanho y, ' ...
            'valor positivo: barra branca de tamanho y']);
        hold all;
        stem([zeros(1, inicioG1 - 1) firstGroup], 'Marker', 'none', ...
           'LineWidth', 3);
        stem([zeros(1, inicioG2 - 1) secondGroup], 'Marker', 'none', ...
           'LineWidth', 3);
        hold off;
    end

end