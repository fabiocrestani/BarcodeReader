function firstDigit = identifyFirstDigit(firstDigitExtracted, miniOCR)
% Redimensiona imagem de entrada e compara com os 10 dígitos possíveis

    firstDigitResized = imresize(firstDigitExtracted, size(miniOCR{1}));
    
    diferencas = zeros(1, length(miniOCR));
    
    for j = 1 : length(miniOCR)
        diferencaAbsoluta = abs(firstDigitResized - miniOCR{j});
        diferencas(j) = mean(diferencaAbsoluta(:));
    end
    
    [~, indexMaiorProximidade] = min(diferencas);
    firstDigit = indexMaiorProximidade - 1;
end