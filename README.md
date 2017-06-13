# BarcodeReader

Um decodificador de códigos de barras EAN-13 através de processamento de imagem.
Projeto final da disciplina de Processamento Digital de Imagens da UTFPR Câmpus Curitiba.

## Branches
O projeto têm quatro branches principais:
* decodificacao-imagens-artificiais: Decodificação de códigos de barras aritificiais
* decodificacao-colunas: Decodificação de códigos de barras reais pelo método das médias das colunas
* deteccao-reais: Detecção do código de barras em fotos
* master: Usa a saída da detecção de imagens reais como entrada na decodificação de imagens reais
As demais branches são irrelevantes

## Como usar
* Basta baixar todos os arquivos e rodar o script.
* Para alterar o set de imagens, editar a linha: ```setFolder = 'imageSets/set3-cropped-random';```
* Se os arquivos não forem .png, editar a linha: ```imageFiles = dir([setFolder '/*.png']);```

## Referências:
* https://www.free-barcode-generator.net/ean-13/
* https://en.wikipedia.org/wiki/International_Article_Number

## Diagrama de blocos:
![digrama de blocos](https://raw.githubusercontent.com/fabiocrestani/BarcodeReader/Estrat%C3%A9gia2/docs/DiagramaDeBlocosNivel1-ProjetoPDI-BarCodeReader.png "")

## Resultados

### set3-cropped-random
Conjunto de 220 imagens bem formatadas
Acertos: 97.3%

### set2-fotos
?