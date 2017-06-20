function [extractedBarCodeHD, boundingBoxHD] = getFullSizeBarCode(...
    image, scale, boundingBoxSD)
%  Recorta código de barras da imagem original

    boundingBoxHD = boundingBoxSD*(1/scale);
    extractedBarCodeHD = imcrop(image, boundingBoxHD);

end