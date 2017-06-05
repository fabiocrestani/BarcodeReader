function [extractedBarCode1] = barCodeExtractionPhase1(image, debug)

    MIN_AREA = 1000;
    EXPECTED_RATIO = 0.9;
    BOUNDING_BOX_MARGIN = -1;

    % Calcula gradientes, módulo e ângulo
    [Gx, Gy] = imgradientxy(image);
    [Gmag, Gdir] = imgradient(Gx, Gy);
    Gdir = abs(Gdir);
    
    % Calcula e aplica máscara
    GdirX = Gdir;
    GdirY = Gdir;
    mascaraNegadaX = ~(Gdir > 150);
    mascaraNegadaY = ~(Gdir < 20);
    Gdir(mascaraNegadaX & mascaraNegadaY) = 0;
    G = Gmag .* Gdir;
    if debug
        figure; 
        subplot(221); imshow(mascaraNegadaX); title('Máscara negada X');
        subplot(222); imshow(mascaraNegadaY); title('Máscara negada Y');
        subplot(223); imshow(mascaraNegadaX & mascaraNegadaY); 
        title('Máscara negada X AND Máscara negada Y');
        subplot(224); imshow(G); title('Resultado');
    end
        
    % Mediana assimétrica para manter apenas linhas verticais
    Gmed = medfilt2(G, [15 3]);
    if debug
        figure; imshow(Gmed); 
        title('Mediana assimétrica para manter apenas linhas verticais');
    end
    
    % Box filter
    Gbox = imboxfilt(Gmed, 15);
    Gbox = Gbox > 0.5;
    if debug
        figure; imshow(Gbox); title('Box filter');
    end
    
    % Encontra blobs
    stats = regionprops(Gbox);
    if debug
        figure; imshow(Gbox); title('Blobs'); hold on;
    end
    for j = 1 : numel(stats)
        boundingBox = stats(j).BoundingBox;
        if debug
            rectangle('Position', boundingBox, 'Linewidth', 2, ...
                'EdgeColor', 'y');
        end

        area = stats(j).Area;
        razao = boundingBox(4)/boundingBox(3);
        if area < MIN_AREA
            area = 0;
            razao = 0;
        end
        areas(j) = area;
        razoes(j) = razao;    
    end
    
    % Pega razão mais próxima do esperado
    razoes = abs(razoes - EXPECTED_RATIO);
    [~, minIndex] = min(razoes);
    boundingBox = stats(minIndex).BoundingBox;
    boundingBox(1:2) = boundingBox(1:2) - BOUNDING_BOX_MARGIN;
    boundingBox(3:4) = boundingBox(3:4) + 2*BOUNDING_BOX_MARGIN;
    if debug
        rectangle('Position', boundingBox, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
    end
    %area = stats(minIndex).Area;    
    extractedBarCode1 = imcrop(image, boundingBox);
    extractedBarCode1 = uint8(mat2gray(extractedBarCode1)*255);

    % Resultado
    if debug
        figure; imshow(extractedBarCode1); 
        title('Código de barras extraído');
    end
end