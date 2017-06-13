function [groupNumber, groupString] = ... 
    decodeGroup(groupDigits, firstDigit)
% Aplica decodeDigits para cada dígito do grupo e monta número

    switch nargin
        case 1
            code = 'RRRRRR';
        case 2
            switch firstDigit
                case 0, code = 'LLLLLL';
                case 1, code = 'LLGLGG';
                case 2, code = 'LLGGLG';
                case 3, code = 'LLGGGL';
                case 4, code = 'LGLLGG';
                case 5, code = 'LGGLLG';
                case 6, code = 'LGGGLL';
                case 7, code = 'LGLGLG';
                case 8, code = 'LGLGGL';                                
                case 9, code = 'LGGLGL';
                otherwise
                    error('Erro em decodeGroup: firstDigit inválido');
            end
        otherwise
            error('Erro em decodeGroup: Número de argumentos inválido');
    end

    NUMBER_OF_DIGITS = 6;

    groupNumber = zeros(1, NUMBER_OF_DIGITS);
    groupString = [];
    
    for k = 1 : NUMBER_OF_DIGITS
        groupNumber(k) = decodeDigits(groupDigits(k, :), code(k));
        groupString = strcat(groupString, int2str(groupNumber(k)));
    end
end