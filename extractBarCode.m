function extracted = extractBarCode(input)

    MIN_AREA = 1000;
    EXPECTED_RATIO = 0.9;
    BOUNDING_BOX_MARGIN = 1;

    inputImage = mat2gray(input);               % Entrada
    image = imboxfilt(input, 7);                % Box filter
    image = im2bw(image, graythresh(image));    % Limiarização
    image = imcomplement(image);                % Complemento

    edges = imfill(imgradient(image));          % Gradiente
    edges = imboxfilt((255*edges), 3);          % Box filter em uint8
    edges = im2bw(edges, graythresh(edges));    % Limiarização
    edges = bwareaopen(edges, MIN_AREA);        % Remove blobs pequenos

    stats = regionprops(edges);

    figure; imshow(edges); 

    hold on;
    for i = 1 : numel(stats)
       boundingBox = stats(i).BoundingBox;
       rectangle('Position', boundingBox, 'Linewidth', 2, 'EdgeColor', 'y');
       areas(i) = stats(i).Area;
       razoes(i) = boundingBox(4)/boundingBox(3);
    end

    razoes = abs(razoes - EXPECTED_RATIO);
    [~, minIndex] = min(razoes);

    boundingBox = stats(minIndex).BoundingBox;
    boundingBox(1:2) = boundingBox(1:2) - BOUNDING_BOX_MARGIN;
    boundingBox(3:4) = boundingBox(3:4) + 2*BOUNDING_BOX_MARGIN;
    rectangle('Position', boundingBox, 'Linewidth', 2, 'EdgeColor', 'g');
    area = stats(minIndex).Area;

    extracted = imcrop(inputImage, boundingBox);
    
end