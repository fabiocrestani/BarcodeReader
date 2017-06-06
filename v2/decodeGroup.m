function [groupNumber, groupString] = ... 
    decodeGroup(secondGroupDigits, firstDigit)
% Aplica decodeDigits para cada dígito do grupo e monta número

    switch nargin
        case 1
            code = 'r';
        case 2
            % TODO determinar código baseado no primeiro dígito 
            % code = code;
            code = 'r';
        otherwise
            error('Erro em decodeGroup: Número de argumentos inválido');
    end

    NUMBER_OF_DIGITS = 6;

    groupNumber = zeros(1, NUMBER_OF_DIGITS);
    groupString = [];
    
    for k = 1 : NUMBER_OF_DIGITS
        groupNumber(k) = decodeDigits(secondGroupDigits(k, :), code);
        groupString = strcat(groupString, int2str(groupNumber(k)));
    end
end