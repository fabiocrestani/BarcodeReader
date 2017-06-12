function [barWidths, firstGroup, secondGroup] = ...
    splitGroups(croppedBarCode, debug)
% Separa primeiro e segundo grupo
 
    croppedBarCode = imadjust(croppedBarCode);

    % Calcula gradientes, módulo e ângulo
    [Gx, ~] = imgradientxy(croppedBarCode);
    
    % Faz a média por coluna
    GxMean = mean(Gx, 1);
    GxMean2 = GxMean;

    % Aplica dois thresholds
    threshold = max(GxMean(:))/8;
    GxMean2(abs(GxMean) < threshold) = 0;
    GxMean2(GxMean > threshold) = 1;
    GxMean2(GxMean < -threshold) = -1;
    
    if debug
        figure;
        subplot(221); imshow(croppedBarCode); 
        title('extractedBarCode3');
        subplot(222); stem(GxMean, 'Marker', 'x', 'LineWidth', 1); 
        title('GxMean'); grid;
        t = 1:0.1:200;
        hold on; 
        plot(t, ones(size(t))*threshold, 'r', 'LineWidth', 1);
        plot(t, -1*ones(size(t))*threshold, 'r'); 
        hold off;
        subplot(223); stem(GxMean2, 'Marker', 'none', 'LineWidth', 2); 
        title('GxMean2');
    end
    
    % Percorre da esquerda para a direita contando o tamanho das áreas
    % brancas e pretas. Procura uma mudança no sinal daquele ponto
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
        subplot(224); stem(bars, 'Marker', 'none', 'LineWidth', 2); 
        title('bars');
    end
        
    bars = bars*255;
    barsPlot = repmat(bars, [100 1]);
    
    % Conta o número de barras
    barsAcum = 0;
    for k = 2 : length(barWidths)
        barsAcum(k) = barsAcum(k - 1) + abs(barWidths(k));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO
    % Isso aqui não ficou robusto o suficiente
    % Levar em consideração a largura da imagem ??
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    acumWidth = barsAcum(length(barsAcum));
    %maxWidthBar = max(barWidths)
    maxWidthBar = 5;
    %fprintf('acumWidth: %d\n', acumWidth);
    coef = acumWidth / (6*7);
    coef = coef / maxWidthBar;
    %barWidths = round(barWidths * (3/5));
    barWidths = round(barWidths * coef);
    

    
%     barWidths
%     % Separa os grupos
%     trio = [];
%     eventos = [];
%     for i = 1 : length(barWidths) - 3
%         trio = barWidths(i : i+2);
%         if trio == [1 -1 1]
%             eventos = [eventos i];
%         end
%     end
%     eventos(1)
    
    inicioG1 = 4;
    fimG1 = 27;
    inicioG2 = 33;
    fimG2 = 56;
    
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
        
    if debug
        %subplot(313); stem(barsAcum); title('barsAcum'); grid;
    end

end