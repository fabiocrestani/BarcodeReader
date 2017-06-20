function [output] = convertIfColorImage(input)
% Converte para escala de cinza se imagem de entrada é colorida
    
    [~, ~, channelNumber] = size(input);
    if channelNumber == 3
        output = rgb2gray(input);
        output = mat2gray(output);
    else
        output = mat2gray(input);
    end
    
end