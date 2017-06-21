%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Universidade Tecnol�gica Federal do Paran�                             %
% Curitiba, PR                                                           %
% Engenharia Eletr�nica                                                  %
% Processamento Digital de Imagens                                       %
%                                                                        %
% Projeto final da disciplina                                            %
% Leitor de c�digos de barras EAN-13                                     %
% https://pt.wikipedia.org/wiki/EAN-13                                   %
%                                                                        %
% Autor: F�bio Crestani                                                  %
% Email: crestani.fabio@gmail.com                                        %
% GitHub: https://github.com/fabiocrestani/BarcodeReader                 %
%                                                                        %
% Branch: master                                                         %
% Vers�o 1.0.1                                                           %
% 21/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

list = {'Decodifica��o de imagens artificiais', ...
'Decodifica��o de imagens reais', 'Detec��o em imagens reais'};

[value, ok] = listdlg('PromptString', 'Selecione um algoritmo:', ...
					  'SelectionMode', 'single', 'ListString', list, ...
                      'ListSize', [300, 100]);
				
if ok == 1
    if value == 1
        addpath('decodificacao-imagens-artificiais');
 		run('decodificacao-imagens-artificiais/main.m');
    elseif value == 2
        addpath('decodificacao-imagens-reais');
 		run('decodificacao-imagens-reais/main.m');
    elseif value == 3
        addpath('deteccao-imagens-reais');
 		run('deteccao-imagens-reais/main.m');
    else 
        disp('Nada selecionado');
    end
end


