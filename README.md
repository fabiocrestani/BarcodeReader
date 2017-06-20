# BarcodeReader

Um decodificador de códigos de barras EAN-13 através de processamento de imagem.
Projeto final da disciplina de Processamento Digital de Imagens da UTFPR Câmpus Curitiba.

## Branches
O projeto têm quatro branches principais:
* decodificacao-imagens-artificiais: Decodificação de códigos de barras artificiais para validação da ideia do algoritmo de decodificação
* decodificacao-colunas: Decodificação de códigos de barras reais pelo método das médias das colunas
* deteccao-reais: Detecção do código de barras reais em fotos
* master: Une as três branches anteriores e permite selecionar qual delas se deseja rodar.

A branch decodificacao-gradientes faz a decodificação através do método do gradiente horizontal, mas foi abandonada pois o método das médias das colunas apresentou melhor resultado.

## Como usar
* TODO

## Referências:
* https://www.free-barcode-generator.net/ean-13/
* https://en.wikipedia.org/wiki/International_Article_Number

## Diagrama de blocos:
![digrama de blocos](https://raw.githubusercontent.com/fabiocrestani/BarcodeReader/master/docs/DiagramaDeBlocosNivel1-ProjetoPDI-BarCodeReader.png "")

## Resultados

### decodificacao-imagens-artificiais
* Conjunto de 220 imagens bem formatadas
* Acertos: 98.6 %

### decodificacao-colunas
* Conjunto de 19 imagens de códigos de barras recortados
* Acertos: 36.8 %
* Média de 5.3 dígitos errados por código de barras

### deteccao-reais
* Conjunto de 19 fotos de códigos de barras
* ?
