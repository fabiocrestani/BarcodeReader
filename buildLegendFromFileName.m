function [inputLegend, firstGroup, secondGroup, id] = ...
    buildLegendFromFileName(currentFileName)
% Extrai código para conferência a partir do nome do arquivo
    id = currentFileName(1);
    firstGroup = currentFileName(2:7);
    secondGroup = currentFileName(8:13);
    inputLegend = [currentFileName(1) ' ' firstGroup ' ' secondGroup];    
end