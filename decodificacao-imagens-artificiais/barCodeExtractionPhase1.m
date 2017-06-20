function [extractedBarCode1, boundingBox] = ...
                                barCodeExtractionPhase1(image, debug)
% Extrai o c�digo de barras de uma imagem maior

    MIN_AREA = 1000;
    EXPECTED_RATIO = 0.65;
    BOUNDING_BOX_MARGIN = 0;
    BOX_FILTER_SIZE = 15;

    [m, n] = size(image);
    if m*n > 790*960*2
        BOX_FILTER_SIZE = 25
    end
    
    % Calcula gradientes, m�dulo e �ngulo
    [Gx, Gy] = imgradientxy(image);
    [Gmag, Gdir] = imgradient(Gx, Gy);
    Gdir = abs(Gdir);
    
    % Calcula e aplica m�scara
    mascaraNegadaX = ~(Gdir > 150);
    mascaraNegadaY = ~(Gdir < 20);
    Gdir(mascaraNegadaX & mascaraNegadaY) = 0;
    G = Gmag .* Gdir;
    if debug
        figure; 
        subplot(221); imshow(mascaraNegadaX); title('M�scara negada X');
        subplot(222); imshow(mascaraNegadaY); title('M�scara negada Y');
        subplot(223); imshow(mascaraNegadaX & mascaraNegadaY); 
        title('M�scara negada X AND M�scara negada Y');
        subplot(224); imshow(G); title('Resultado');
    end
        
    % Mediana assim�trica para manter apenas linhas verticais
    Gmed = medfilt2(G, [BOX_FILTER_SIZE round(BOX_FILTER_SIZE/5)]);
    if debug
        figure; imshow(Gmed); 
        title('Mediana assim�trica para manter apenas linhas verticais');
    end
    
    % Box filter
    Gbox = imboxfilt(Gmed, BOX_FILTER_SIZE);
    Gbox = Gbox > 0.5;
    if debug
        figure; imshow(Gbox); title('Box filter');
    end
    
    % Encontra blobs
    stats = regionprops(Gbox, 'Area', 'BoundingBox', 'FilledImage');
    if debug
        figure; imshow(Gbox); title('Blobs'); hold on;
    end
    numElements = numel(stats);
    areas = zeros(1, numElements);
    razoes = areas;
    for j = 1 : numElements;
        boundingBox = stats(j).BoundingBox;
        if debug
            rectangle('Position', boundingBox, 'Linewidth', 2, ...
                'EdgeColor', 'y');
        end

        area = stats(j).Area;
        razao = boundingBox(4)/boundingBox(3);
        if area > MIN_AREA
            areas(j) = area;
            razoes(j) = razao;
        end
    end
    
    % Pega raz�o mais pr�xima do esperado
    razoes = abs(razoes - EXPECTED_RATIO);
    [~, minIndex] = min(razoes);
    boundingBox = stats(minIndex).BoundingBox;
    %boundingBox(1:2) = boundingBox(1:2) - BOUNDING_BOX_MARGIN;
    boundingBox(3:4) = boundingBox(3:4) - 1;
    if debug
        rectangle('Position', boundingBox, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
    end
    
    % Cropa regi�o da imagem original
    extractedBarCode1 = imcrop(image, boundingBox);
    extractedBarCode1 = uint8(mat2gray(extractedBarCode1)*255);
    
    % Pega apenas regi�o do blob selecionado e usa como m�scara
    %filledImage = stats(minIndex).FilledImage;
    %extractedBarCode1 = extractedBarCode1 .* filledImage;
    
    % Resultado
    if debug
        figure; imshow(extractedBarCode1); 
        title('C�digo de barras extra�do');
    end
end