loaded = load('miniOCR/oito.mat');
oito = loaded.firstDigitExtracted;
figure;
imshow(oito);

% TODO gerar c�digos de barras para todos os n�meros de 0 a 9 para poder
% determinar o miniOCR do primeiro d�gito