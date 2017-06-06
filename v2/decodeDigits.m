function [number, rank] = decodeDigits(digits, code)
% Traduz os bits do d�gito para um n�mero de 0 a 9, de acordo com a
% especifica��o do EAN-13: https://pt.wikipedia.org/wiki/EAN-13

    % TODO: tratar os c�digos L e G tamb�m

    R_CODE = [1 1 1 0 0 1 0; % 0
              1 1 0 0 1 1 0; % 1
              1 1 0 1 1 0 0; % 2
              1 0 0 0 0 1 0; % 3
              1 0 1 1 1 0 0; % 4
              1 0 0 1 1 1 0; % 5
              1 0 1 0 0 0 0; % 6
              1 0 0 0 1 0 0; % 7
              1 0 0 1 0 0 0; % 8
              1 1 1 0 1 0 0; % 9
              ];
              
    if code == 'R' || code == 'r'
        CODE = R_CODE;
    else
        error('C�digo inv�lido');
    end
        
    digits = ~digits;
    distance = zeros(1, 10);
    for i = 1 : 10
        distance(i) = sum(abs(digits - CODE(i, :)));
    end
    
    number = find(distance == min(distance), 1, 'first') - 1;
    rank = min(distance)/7;
end