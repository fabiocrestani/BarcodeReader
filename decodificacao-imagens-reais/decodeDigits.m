function [number, rank] = decodeDigits(digits, code)
% Traduz os bits do dígito para um número de 0 a 9, de acordo com a
% especificação do EAN-13: https://pt.wikipedia.org/wiki/EAN-13
         
    G_CODE = [0 1 0 0 1 1 1; % 0
              0 1 1 0 0 1 1; % 1
              0 0 1 1 0 1 1; % 2
              0 1 0 0 0 0 1; % 3
              0 0 1 1 1 0 1; % 4
              0 1 1 1 0 0 1; % 5
              0 0 0 0 1 0 1; % 6
              0 0 1 0 0 0 1; % 7
              0 0 0 1 0 0 1; % 8
              0 0 1 0 1 1 1; % 9
              ];

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
          
    L_CODE = ~R_CODE;
              
    switch code 
        case 'R', CODE = R_CODE;
        case 'r', CODE = R_CODE;
        case 'L', CODE = L_CODE;
        case 'l', CODE = L_CODE;
        case 'G', CODE = G_CODE;
        case 'g', CODE = G_CODE;            
        otherwise, error('Código inválido');
    end
        
    NUMBER_OF_CODES = 10;
    digits = ~digits;
    distance = zeros(1, NUMBER_OF_CODES);
    for i = 1 : NUMBER_OF_CODES 
        distance(i) = sum(abs(digits - CODE(i, :)));
    end
    
    number = find(distance == min(distance), 1, 'first') - 1;
    rank = min(distance)/7;
end