%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Universidade Tecnológica Federal do Paraná                             %
% Curitiba, PR                                                           %
% Engenharia Eletrônica                                                  %
% Processamento Digital de Imagens                                       %
%                                                                        %
% Projeto final da disciplina                                            %
% Leitor de códigos de barras EAN-13                                     %
% https://pt.wikipedia.org/wiki/EAN-13                                   %
%                                                                        %
% Autor: Fábio Crestani                                                  %
% Email: crestani.fabio@gmail.com                                        %
% GitHub: https://github.com/fabiocrestani/BarcodeReader                 %
%                                                                        %
% Branch: master                                                         %
% Versão 1.0.1                                                           %
% 21/06/2017                                                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc;

list = {'Decodificação de imagens artificiais', ...
'Decodificação de imagens reais', 'Detecção em imagens reais'};

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


