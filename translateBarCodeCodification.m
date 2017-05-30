function [number, rank] = translateBarCodeCodification(digits, code)
% Traduz os bits do dígito para um número de 0 a 9, de acordo com a
% especificação do EAN-13: https://pt.wikipedia.org/wiki/EAN-13

% TODO: tratar os códigos L e G também

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
        
        
        % TODO: 
        % 1. faz a diferença do input com todos da lista,
        % 2. se a diferença de algum for == 0, tem rank = 1 e retorna
        % 3. senão, retorna aquele com a menor diferença
        % 4. neste caso, o rank é o módulo da diferença dividido por 7
        
    end

end