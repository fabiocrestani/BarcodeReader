function [barWidths, firstGroup, secondGroup] = ...
    decodeBarCode(croppedBarCode, debug)
% TODO decodificar o código de barras sem usar gradiente

barWidths = 0;
firstGroup = 0;
secondGroup = 0;


    %croppedBarCode = imadjust(croppedBarCode);
    croppedBarCode = imadjust(croppedBarCode, [], [], 2.5)*1.3;
    croppedBarCode = imsharpen(croppedBarCode);
    croppedBarCodeBeforeBW = croppedBarCode;
    %croppedBarCode = im2bw(croppedBarCode, graythresh(croppedBarCode));
    croppedBarCode = im2bw(croppedBarCode, 0.7);
    
    figure;  
    subplot(211); imshow([croppedBarCodeBeforeBW; 255*croppedBarCode]);
    
    % TODO melhorar a imagem
    
    %se = strel('line', 11, 90);
    %croppedBarCode = imdilate(croppedBarCode, se);
    croppedBarCode = imboxfilt(croppedBarCode, [7, 1]);
    
    subplot(212); imshow([croppedBarCodeBeforeBW; 255*croppedBarCode]);
    
    % Faz a média por coluna
    GxMean = mean(croppedBarCode, 1);
    GxMean2 = GxMean;

    % Aplica dois thresholds
    threshold = 1/10;
    GxMean2(GxMean < threshold) = 0;
    GxMean2(GxMean > threshold) = 1;
    bars = GxMean2;
    
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
        t = 0:0.1:600;
        hold on; 
        plot(t, ones(size(t))*threshold, 'r', 'LineWidth', 1);
        plot(t, -1*ones(size(t))*threshold, 'r'); 
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
    
    if debug
        subplot(224); stem(bars, 'Marker', 'none', 'LineWidth', 2); 
        title('bars');
    end
        
    
    % Remove primeira barra, se for branca
    if barWidths(1) > 0
        barWidths(1) = [];
    end
    
    bars = bars*255;
    barsPlot = repmat(bars, [100 1]);
    
    % Conta o número de barras
    barsAcum = 0;
    for k = 2 : length(barWidths)
        barsAcum(k) = barsAcum(k - 1) + abs(barWidths(k));
    end
    
    % Normaliza larguras
    barWidths = 100 * barWidths / barsAcum(length(barsAcum) - 1);
    barWidths = round(barWidths);
    barWidths(barWidths > 4) = 4;
    barWidths(barWidths==0)=[];
    
    % Separa os dois grupos
    inicioG1 = 5;
    fimG1 = 27;
    inicioG2 = 33;
    fimG2 = 55;
    firstGroup = barWidths(inicioG1 : fimG1);
    secondGroup = barWidths(inicioG2 : fimG2);
    
    if debug
        figure;
        subplot(211); imshow(barsPlot); title('bars'); 
        xlabel('Código de barras reconstruído');
        subplot(212); stem(barWidths, 'Marker', 'none', 'LineWidth', 3); 
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