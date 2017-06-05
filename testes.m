loaded = load('miniOCR/oito.mat');
oito = loaded.firstDigitExtracted;
figure;
imshow(oito);

% TODO gerar códigos de barras para todos os números de 0 a 9 para poder
% determinar o miniOCR do primeiro dígito