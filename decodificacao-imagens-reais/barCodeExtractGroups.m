function [g1, g2] = barCodeExtractGroups(croppedBarCode, debug)
% Devolve os grupos 1 e 2

    croppedBarCode = imadjust(croppedBarCode, [], [], 2.5)*1.3;
    croppedBarCode = imsharpen(croppedBarCode);
    croppedBarCodeBeforeBW = croppedBarCode;
    croppedBarCode = im2bw(croppedBarCode, 0.7);
    
    if debug
        figure; imshow(croppedBarCodeBeforeBW); 
        title('Código de barras redimensionado e cropado');
        figure; imshow(croppedBarCode);
        title('Código de barras redimensionado, cropado e limiarizado');
    end
    
    % Faz a média por coluna
    GxMean = mean(croppedBarCode, 1);
    GxMean2 = GxMean;
    
    % Aplica dois thresholds
    threshold = 1/10;
    GxMean2(GxMean < threshold) = 0;
    GxMean2(GxMean > threshold) = 1;
    
    if debug
        GxMean2Plot = [GxMean2; GxMean2; GxMean2; GxMean2; GxMean2;];
        GxMean2Plot = [GxMean2Plot; GxMean2Plot; GxMean2Plot; GxMean2Plot];
        figure; imshow([255*croppedBarCode; ...
            255*ones(5, length(croppedBarCodeBeforeBW)); ...
            255*GxMean2Plot]); 
        title('Código de barras limiarizado e após cálculo da média por colunas');
        
        figure; stem(GxMean2, 'Marker', 'x', 'LineWidth', 2); 
        title('GxMean2'); grid;
    end
    
    % --------------------------------------------------------------------
    % Pega o primeiro grupo
    % --------------------------------------------------------------------
    % Encontra terceira barra branca
    ant = GxMean2(1);
    numberOfWhiteBars = ant;
    for k = 2 : length(GxMean2)
        if GxMean2(k) ~= ant
            ant = GxMean2(k);
            if ant > 0
                numberOfWhiteBars = numberOfWhiteBars + 1;
            end
            if numberOfWhiteBars == 3
                newStartIndex = k;
                break;
            end
        end
    end
    % Monta bounding boxes iniciais
    [m, n] = size(croppedBarCode);
    w = (n/2);
    bb1 = [newStartIndex 1 w-newStartIndex m];
    g1 = imcrop(GxMean2, bb1);
    % Remove ultima barra preta do grupo 1
    k = length(g1);
    while g1(k) == 0
        g1(k) = [];
        k = k - 1;
    end
    % Remove ultima barra branca do grupo 1
    k = length(g1);
    while g1(k) == 1
        g1(k) = [];
        k = k - 1;
    end
    
    
    % --------------------------------------------------------------------
    % Pega o segundo grupo
    % --------------------------------------------------------------------
    bb2 = [w-1 1 w m];
    g2 = imcrop(GxMean2, bb2);
    % Encontra terceira barra preta
    ant = g2(1);
    numberOfBlackBars = ant;
    for k = 2 : length(g2)
        if g2(k) ~= ant
            ant = g2(k);
            if ant <= 0
                numberOfBlackBars = numberOfBlackBars + 1;
            end
            if numberOfBlackBars == 2
                newStartIndex = k;
                break;
            end
        end
    end
    
    bb2(1) = bb2(1) + newStartIndex;
    bb2(3) = length(g1);
    g2 = imcrop(GxMean2, bb2);
    
    
    % Resultados
    if debug
        figure; imshow(repmat(GxMean2, 30, 1));
        title('Divisão dos grupos');
        hold on;
        rectangle('Position', bb1, 'Linewidth', 1, 'EdgeColor', 'b');
        rectangle('Position', bb2, 'Linewidth', 1, 'EdgeColor', 'r');
        hold off; 
        figure;
        subplot(211); imshow(repmat(g1, 20, 1)); title('Grupo 1');
        subplot(212); imshow(repmat(g2, 20, 1)); title('Grupo 2');
    end
    
end