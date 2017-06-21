function [firstDigit] = computeFirstDigitFromGroupParity(group)
% Calcula a paridade de um grupo

    % Inverte nível lógico do grupo
    group = ~group;

    O = 0; % ODD
    E = 1; % EVEN
    
    % Calcula paridades
    parities = zeros(1, 6);
    for i = 1 : 6	
        % Conta o número de 1s
        digito = group(i, :);
        numOfOnes = sum(digito);
        if mod(numOfOnes, 2) == 0
            parities(i) = E;  	% par
        else
            parities(i) = O;	% impar
        end
    end
	
	% Bate o vetor de paridades com a tabela para determinar o 1o dígito
	EAN_PARITIES = [O O O O O O;	% Primero dígito = 0
					O O E O E E;	% Primero dígito = 1
					O O E E O E;	% Primero dígito = 2
					O O E E E O;	% Primero dígito = 3
					O E O O E E;	% Primero dígito = 4
					O E E O O E;	% Primero dígito = 5
					O E E E O O;	% Primero dígito = 6
					O E O E O E;	% Primero dígito = 7
					O E O E E O; 	% Primero dígito = 8
					O E E O E O;	% Primero dígito = 9
					];

    difs = zeros(1, 10);					
	for i = 1 : 10
		dif = EAN_PARITIES(i, :) - parities;
		difs(i) = sum(abs(dif));
	end
	
	% Procura pelo índice de menor diferença
    firstDigit = find(difs == min(difs), 1, 'first') - 1;
	
end