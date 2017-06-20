function [extractedBarCode1, boundingBox] = ...
                                barCodeExtractionPhase1(image, debug)
% Extrai o código de barras de uma imagem maior

    [m, n] = size(image);
    MIN_AREA = m*n/100;
    EXPECTED_RATIO = 2;
    BOX_FILTER_SIZE = 9;
    
    % Calcula gradientes, módulo e ângulo
    [Gx, Gy] = imgradientxy(image);
    [Gmag, Gdir] = imgradient(Gx, Gy);
    Gdir = abs(Gdir);
    
    if debug
        figure; imshowpair(image, mat2gray(Gdir), 'montage'); 
        title('Input | Gdir');
    end
    
    % Calcula e aplica máscara
    mascaraX = (Gdir > 160) | (Gdir < 10);
    mascaraYnegada = ~((Gdir < 110) & (Gdir > 75));
    Gdir(mascaraX & mascaraYnegada) = 0;
    G = ~(abs(Gmag) .* Gdir);
    if debug
        figure; 
        subplot(221); imshow(mascaraX); title('Máscara X');
        subplot(222); imshow(mascaraYnegada); title('Máscara Y negada');
        subplot(223); imshow(mascaraX & mascaraYnegada); 
        title('Máscara X AND Máscara negada Y');
        subplot(224); imshow(G); title('Máscara de Gdir * Gmag');
    end
        
    % Mediana assimétrica para manter apenas linhas verticais
    Gmed = medfilt2(G, [BOX_FILTER_SIZE round(BOX_FILTER_SIZE/5)]);
    if debug
        figure; imshow(Gmed); 
        title('Mediana assimétrica para manter apenas linhas verticais');
    end
    
    % Box filter
    Gbox = imboxfilt(Gmed, BOX_FILTER_SIZE);
    Gbox = Gbox > 0.5;
    if debug
        figure; imshow(Gbox); title('Box filter');
    end
    
    % Encontra blobs
    stats = regionprops(Gbox, 'Area', 'BoundingBox', 'FilledImage', ...
        'Solidity');
    if debug
        figure; imshow(Gbox); title('Blobs'); hold on;
    end
    numElements = numel(stats);
    areas = zeros(1, numElements);
    razoes = areas;
    solidezes = areas;
    for j = 1 : numElements;
        boundingBox = stats(j).BoundingBox;
        if debug
            rectangle('Position', boundingBox, 'Linewidth', 2, ...
                'EdgeColor', 'y');
        end

        % Pega parâmetros
        area = stats(j).Area;
        razao = boundingBox(3)/boundingBox(4);
        solidity = stats(j).Solidity;
        
        % Filtra por área, razão largura-altura, solidez (proporção de 
        % pixels dentro da bounding box) e orientação (mais horizontal)
        if area > MIN_AREA && solidity > 0.4 && razao > 1
            areas(j) = area;
            razoes(j) = razao;
            solidezes(j) = solidity;
            if debug
                rectangle('Position', boundingBox, 'Linewidth', 2, ...
                    'EdgeColor', 'b');
            end
            %pause
        end
    end
    
    % Pega razão mais próxima do esperado
    razoes = abs(razoes - EXPECTED_RATIO);
    [~, minIndex] = min(razoes);
    boundingBox = stats(minIndex).BoundingBox;
    boundingBox(3:4) = boundingBox(3:4) - 1;
    
    % Pega maior orientation
%     [or, minOrientationIndex]= min(orientations);
%     or
%     boundingBox = stats(minOrientationIndex).BoundingBox;
%     boundingBox(3:4) = boundingBox(3:4) - 1;
    
    if debug
        rectangle('Position', boundingBox, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
    end
    
    % Cropa região da imagem original
    extractedBarCode1 = imcrop(image, boundingBox);
    extractedBarCode1 = uint8(mat2gray(extractedBarCode1)*255);
   
    % Resultado
    if debug
        figure; imshow(extractedBarCode1); 
        title('Código de barras extraído');
    end
end