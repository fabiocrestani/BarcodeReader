% Monta uma struct do miniOCR a partir dos arquivos .mat
clear all;
close all;
clc;

zero   = load('zero.mat');
um     = load('um.mat');
dois   = load('dois.mat');
tres   = load('tres.mat');
quatro = load('quatro.mat');
cinco  = load('cinco.mat');
seis   = load('seis.mat');
sete   = load('sete.mat');
oito   = load('oito.mat');
nove   = load('nove.mat');

miniOCR{1}  = zero.firstDigitExtracted;
miniOCR{2}  = um.firstDigitExtracted;
miniOCR{3}  = dois.firstDigitExtracted;
miniOCR{4}  = tres.firstDigitExtracted;
miniOCR{5}  = quatro.firstDigitExtracted;
miniOCR{6}  = cinco.firstDigitExtracted;
miniOCR{7}  = seis.firstDigitExtracted;
miniOCR{8}  = sete.firstDigitExtracted;
miniOCR{9}  = oito.firstDigitExtracted;
miniOCR{10} = nove.firstDigitExtracted;


save('miniOCR.mat', 'miniOCR');