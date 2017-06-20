function [errors] = countNumberOfWrongDigits(firstGroupString, ...
    secondGroupString, firstGroupExptd, secondGroupExptd)
% Conta o número de dígitos errados em relação ao resultado esperado

    if length(firstGroupString) ~= length(firstGroupExptd) || ...
        length(secondGroupString) ~= length(secondGroupExptd)
        error(['Error: countNumberOfWrongDigits. Tamanho incoerente' ...
            ' das strings']);
    end
    
    errors = 0;
       
    for i = 1 : length(firstGroupString)
        if firstGroupString(i) ~= firstGroupExptd(i)
            errors = errors + 1;
        end
    end
    
    for i = 1 : length(secondGroupString)
        if secondGroupString(i) ~= secondGroupExptd(i)
            errors = errors + 1;
        end
    end

end