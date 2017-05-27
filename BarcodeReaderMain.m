% Leitor de c�digos de barras EAN-13
% Vers�o 0.0

close all;
clear all;
clc;

setFolder = 'set1';
imageFiles = dir([setFolder '/*.png']);      
numerOfFiles = length(imageFiles);
for i = 1 : numerOfFiles
    currentFileName = imageFiles(i).name;
    images{i} = imread([setFolder '/' currentFileName]);

    inputImage = mat2gray(images{i});
    
    image = imboxfilt(inputImage, 7);
    
    image = im2bw(image, graythresh(image));
    image = imcomplement(image);    
    
    edges = imfill(imgradient(image));
    edges = imboxfilt((255*edges), 3);
    edges = im2bw(edges, graythresh(edges));
    
    % TODO procurar pelo blob com a propor��o largura-altura mais pr�xima
    % do esperado para um c�digo de barras
    
    % find both black and white regions
    stats = [regionprops(edges); regionprops(not(edges))];
    
    figure; imshow(image);
    figure; imshow(edges); 
    
    hold on;
    for i = 1 : numEl(stats)
       rectangle('Position', stats(i).BoundingBox, 'Linewidth', 2, 'EdgeColor', 'y');
       stats(i).Area
    end
        
    
end