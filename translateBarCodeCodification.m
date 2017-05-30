function [number, rank] = translateBarCodeCodification(digits, code)
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
        
        
        % TODO: 
        % 1. faz a diferen�a do input com todos da lista,
        % 2. se a diferen�a de algum for == 0, tem rank = 1 e retorna
        % 3. sen�o, retorna aquele com a menor diferen�a
        % 4. neste caso, o rank � o m�dulo da diferen�a dividido por 7
        
    end

end