% Renomeia todos os arquivos de uma pasta
% Adaptado de: https://www.mathworks.com/matlabcentral/answers/1760-how-to-rename-a-bunch-of-files-in-a-folder

close all; clear all; clc;

% Get all PDF files in the current folder
folder = 'imageSets/temp/'
files = dir([folder '*.png']);

% Loop through each
for index = 1:length(files)
    
    % Get the file name (minus the extension)
    [~, fileName] = fileparts(files(index).name);
    
    % Modifica nome do arquivo
    fileName = fileName(8 : length(fileName));
    
    % Renomeia
    movefile([folder files(index).name], [folder fileName '.png']);
end

disp('done');