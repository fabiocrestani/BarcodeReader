function [barWidths, firstGroup, secondGroup] = ...
    splitGroups(extractedBarCode2, debug)
% Separa primeiro e segundo grupo

    % Cropa c�digo de barras novamente
    [m, n] = size(extractedBarCode2);
    extractedBarCode3 = imcrop(extractedBarCode2, ...
                                    [1, (m/3), n, m - 2*(m/3)]);
    
    % Calcula gradientes, m�dulo e �ngulo
    [Gx, ~] = imgradientxy(extractedBarCode2);
    
    % Faz a m�dia por coluna
    GxMean = mean(Gx, 1);
    GxMean2 = GxMean;

    % Aplica dois thresholds
    threshold = max(GxMean(:))/2;
    GxMean2(abs(GxMean) < threshold) = 0;
    GxMean2(GxMean > threshold) = 1;
    GxMean2(GxMean < -threshold) = -1;
    
    if debug
        figure;
        subplot(311); imshow(extractedBarCode3); 
        title('extractedBarCode3');
        subplot(312); stem(GxMean); title('GxMean');
        subplot(313); stem(GxMean2); title('GxMean2');
    end
    
    % Percorre da esquerda para a direita contando o tamanho das �reas
    % brancas e pretas. Procura uma mudan�a no sinal daquele ponto
    % ignorando as passagens por zero
    bars = zeros(1, length(GxMean2));
    previous = -1;
    barNumber = 0;
    barWidth = 1;
    for k = 2 : length(GxMean2)
        if GxMean2(k) ~= previous && GxMean2(k) ~= 0
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
        bars(k) = previous > 0;
    end
    
    if debug
        figure; 
        subplot(211); stem(GxMean2); title('GxMean2'); 
        subplot(212); stem(bars);
    end
        
    bars = bars*255;
    barsPlot = repmat(bars, [100 1]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO
    % Isso aqui n�o ficou robusto o suficiente
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    barWidths = round(barWidths * (3/5));
    
    if debug
        figure;
        subplot(311); imshow(barsPlot); title('bars'); 
        xlabel('C�digo de barras reconstru�do');
        subplot(312); stem(barWidths); title('barWidths'); grid;
        xlabel(['Valor negativo: barra preta de tamanho y, ' ...
            'valor positivo: barra branca de tamanho y']);
    end
    
    barsAcum = 0;
    for k = 2 : length(barWidths)
        barsAcum(k) = barsAcum(k - 1) + abs(barWidths(k));
    end
    
    if debug
        subplot(313); stem(barsAcum); title('barsAcum'); grid;
    end
    
    % Separa os grupos
    firstGroup = barWidths(5:28);
    secondGroup = barWidths(33:56);

end