function [digits] = splitGroupDigits(group)
% Divide e retorna os dígitos de um grupo [num_digits digit_size]

    % Serializa vetor de magnitudes com 1 = branco e 0 = preto
    serialized = [];
    for groupIdx = 1 : length(group)
        temp = group(groupIdx);
        tempMag = abs(temp);
        tempSig = temp > 0;
        for tempMagIdx = 1 : tempMag
            serialized = [serialized tempSig];
        end
    end

    % Percorre grupo serializado e divide em 6 dígitos
    NUM_DIGITS = 6;
    DIGIT_SIZE = 7;
    serializedIdx = 1;
    digits = zeros(NUM_DIGITS, DIGIT_SIZE);
    for digitIdx = 1 : NUM_DIGITS
        for k = 1 : DIGIT_SIZE;
            digits(digitIdx, k) = serialized(serializedIdx);
            serializedIdx = serializedIdx + 1;
        end
    end
    
end