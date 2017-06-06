function [groupNumber, groupString] = ... 
    decodeGroup(secondGroupDigits, firstDigit)
% Aplica decodeDigits para cada d�gito do grupo e monta n�mero

    switch nargin
        case 1
            code = 'r';
        case 2
            % TODO determinar c�digo baseado no primeiro d�gito 
            % code = code;
            code = 'r';
        otherwise
            error('Erro em decodeGroup: N�mero de argumentos inv�lido');
    end

    NUMBER_OF_DIGITS = 6;

    groupNumber = zeros(1, NUMBER_OF_DIGITS);
    groupString = [];
    
    for k = 1 : NUMBER_OF_DIGITS
        groupNumber(k) = decodeDigits(secondGroupDigits(k, :), code);
        groupString = strcat(groupString, int2str(groupNumber(k)));
    end
end