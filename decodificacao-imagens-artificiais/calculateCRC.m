function [correct, crc] = calculateCRC(firstDigit, firstGroup, secondGroup)    
% Calcula CRC
% Referência: https://pt.wikipedia.org/wiki/EAN-13
% Suponhamos que estamos usando o código de barras: 789162731405
% Some todos os dígitos das posições ímpares 
%   (dígitos 7, 9, 6, 7, 1 e 0) 7 + 9 + 6 + 7 + 1 + 0 = 30
% Some todos os dígitos das posições pares 
%   (dígitos 8, 1, 2, 3, 4 e 5). 8 + 1 + 2 + 3 + 4 + 5 = 23
% Multiplique a soma dos dígitos das posições pares por 3. 23 * 3 = 69
% Some os dois resultados das etapas anteriores . 30 + 69 = 99
% Determine o número que deve ser adicionado ao resultado da soma para 
% se criar um múltiplo de 10. 99 + 1 = 100
% Portanto, o dígito verificador é 1.
    
    input = [num2str(firstDigit) firstGroup secondGroup];
    if length(input) < 13
        error('Erro: calculateCRC. Código de barras inválido');
    end
    
    somaImpares = 0;
    somaPares = 0;
    for j = 1 : 2 : 12
        somaImpares = somaImpares + str2double(input(j));
        somaPares = somaPares + str2double(input(j + 1));
    end
    somaCRC = somaImpares + (somaPares * 3);
    crc = 0;
    while mod(somaCRC + crc, 10) ~= 0
        crc = crc + 1;
    end
    
    correct = crc == str2double(input(13));    
end