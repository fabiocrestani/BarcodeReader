function [extractedBarCode1, boundingBox] = ...
                                barCodeExtractionPhase1(image, debug)
% Extrai o código de barras de uma imagem maior

    original = image;
    [m, n] = size(image);
    MIN_AREA = m*n/60;
    MIN_SOLIDITY = 0.6;
    BOX_FILTER_SIZE = 7;
    
    % Calcula gradientes, módulo e ângulo
    [Gx, Gy] = imgradientxy(image);
    [Gmag, Gdir] = imgradient(Gx, Gy);
    Gdir = abs(Gdir);
    
    if debug
        kernel = [-1 -1 -1;-1 8 -1;-1 -1 -1];
        image = imfilter(image, kernel, 'same');
        image = medfilt2(image, [1 1]);
        figure; imshow(image); title('High pass + mediana');
        figure; imshow(Gdir, colormap(flipud(hot))); 
        title('Gdir');
    end
    
    % Calcula e aplica máscara
    mascaraX = (Gdir > 160) | (Gdir < 10);
    mascaraYnegada = ~((Gdir < 110) & (Gdir > 75));
    Gdir(mascaraX & mascaraYnegada) = 0;
    G = ~(abs(Gmag) .* Gdir);
    if debug
        figure; imshow(mascaraX); title('Máscara X');
        figure; imshow(mascaraYnegada); title('Máscara Y negada');
        figure; imshow(mascaraX & mascaraYnegada); 
        title('Máscara X AND Máscara negada Y');
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
        if area > MIN_AREA && solidity > MIN_SOLIDITY && razao > 1 ...
                && razao < 4
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
    [~, minIndex] = max(razoes);
    boundingBox = stats(minIndex).BoundingBox;
    boundingBox(3:4) = boundingBox(3:4) - 1;
    
    if debug
        rectangle('Position', boundingBox, 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
    end
    
    % Cropa região da imagem original
    extractedBarCode1 = imcrop(original, boundingBox);
    extractedBarCode1 = uint8(mat2gray(extractedBarCode1)*255);
   
    % Resultado
    if debug
        figure; imshow(extractedBarCode1); 
        title('Código de barras extraído');
    end
end