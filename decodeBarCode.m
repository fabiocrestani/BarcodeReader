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

end