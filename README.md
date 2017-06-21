# BarcodeReader

Um decodificador de códigos de barras EAN-13 através de processamento de imagem.

Projeto final da disciplina de Processamento Digital de Imagens da UTFPR Câmpus Curitiba.

## Branches
O projeto têm quatro branches principais:
* decodificacao-imagens-artificiais: Decodificação de códigos de barras artificiais para validação da ideia do algoritmo de decodificação
* decodificacao-colunas: Decodificação de códigos de barras reais pelo método das médias das colunas
* deteccao-reais: Detecção do código de barras reais em fotos
* master: Une as três branches anteriores e permite selecionar qual delas se deseja rodar.

## Como usar
A partir da branch master, rodar o script main.m, o qual permite escolher qual dos algoritmos será executado:
![Seleção do algoritmo](https://raw.githubusercontent.com/fabiocrestani/BarcodeReader/842e2dced64c1662132977ba590c6f740b5ad898/docs/readme/telaInicial.png "")

Para utilizar outro conjunto de imagens, basta modificar o conteúdo dos datasets de cada algoritmo:
![Seleção do algoritmo](https://raw.githubusercontent.com/fabiocrestani/BarcodeReader/842e2dced64c1662132977ba590c6f740b5ad898/docs/readme/imageSets.png "")

## Relatório
* TODO

## Referências
* https://www.free-barcode-generator.net/ean-13/
* https://en.wikipedia.org/wiki/International_Article_Number

## Código fonte
https://github.com/fabiocrestani/BarcodeReader
