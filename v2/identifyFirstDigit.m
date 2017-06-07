function firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR)
% Redimensiona imagem de entrada e compara com os 10 dígitos possíveis

    firstDigitResized = imresize(firstDigitExtracted, size(miniOCR{1}));
    
    FILTER_SIZE = 5;
    firstDigitResized = imboxfilt(firstDigitResized, FILTER_SIZE);
    
    diferencas = zeros(1, length(miniOCR));
    
    for j = 1 : length(miniOCR)
        miniOCRDigit = imboxfilt(miniOCR{j}, FILTER_SIZE);
        %diferencaAbsoluta = abs(firstDigitResized - miniOCR{j});
        diferencaAbsoluta = abs(firstDigitResized - miniOCRDigit);
        
        diferencas(j) = mean(diferencaAbsoluta(:));
    end
    
    [~, indexMaiorProximidade] = min(diferencas);
    firstDigit = indexMaiorProximidade - 1;
    
    figure; imshow(firstDigitResized); title('First Digit'); xlabel(firstDigit);
end