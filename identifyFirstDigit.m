function [firstDigit] = identifyFirstDigit(firstDigitExtracted, ...
    miniOCR, firstDigitExptd, bypassFirstDigitDecode)
% Redimensiona imagem de entrada e compara com os 10 dígitos possíveis

    if bypassFirstDigitDecode
        firstDigit = str2num(firstDigitExptd);
        return;
    end

    FILTER_SIZE = 5;
    
    firstDigitResized = im2bw(firstDigitExtracted, 0.5);
    figure; imshow(firstDigitResized);
    firstDigitResized = imresize(firstDigitResized, size(miniOCR{1}));
    %firstDigitResized = imboxfilt(firstDigitResized, FILTER_SIZE);
    
    diferencas = zeros(1, length(miniOCR));
    
    for j = 1 : length(miniOCR)
        miniOCRDigit = imboxfilt(miniOCR{j}, FILTER_SIZE);
        diferencaAbsoluta = abs(firstDigitResized - miniOCRDigit);
        diferencas(j) = mean(diferencaAbsoluta(:));
    end
    
    [~, indexMaiorProximidade] = min(diferencas);
    firstDigit = indexMaiorProximidade - 1;
end