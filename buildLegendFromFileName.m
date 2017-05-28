function [legend id, firstGroup, secondGroup] = ...
    buildLegendFromFileName(currentFileName)
  
    id = currentFileName(1);
    firstGroup = currentFileName(2:7);
    secondGroup = currentFileName(8:13);
    legend = [currentFileName(1) ' ' firstGroup ' ' secondGroup];    
    
end