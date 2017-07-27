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

## Figuras
![](https://raw.githubusercontent.com/fabiocrestani/BarcodeReader/master/docs/figuras/figuras4e5.png)
![](https://raw.githubusercontent.com/fabiocrestani/BarcodeReader/master/docs/figuras/figuras6e7.png)

## Trabalho futuro
* Decodificação: Aprimorar a detecção das barras de controle e separação dos grupos.
* Decodificação: Aprimorar a robustez da determinação da largura das barras, o que se mostrou como sendo a maior causa de problemas.
* Decodificação: É possível determinar se o código de barras está invertido, ou seja, se começa da esquerda para a direita, ou da direita para a esquerda. Uma vez detectada a inversão, o código de barras poderia ser decodificado em ambos os casos.
* Detecção: Usar uma estratégia mais robusta para determinar o início e o final exatos do código de barras.
* Detecção: Melhorar correção de rotação e adicionar correção de perspectiva do código de barras.
* Unir detecção e decodificação e validar o algoritmo em um cenário real.

## Relatório
https://github.com/fabiocrestani/BarcodeReader/blob/693a42988414f922a53a868b421102d7d70f033a/docs/Relat%C3%B3rio%20-%20Detec%C3%A7%C3%A3o%20e%20decodifica%C3%A7%C3%A3o%20de%20c%C3%B3digos%20de%20barras.pdf

## Referências
* https://www.free-barcode-generator.net/ean-13/
* https://en.wikipedia.org/wiki/International_Article_Number

## Código fonte
https://github.com/fabiocrestani/BarcodeReader
