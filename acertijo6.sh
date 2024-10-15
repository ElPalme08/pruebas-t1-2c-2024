#!/bin/bash

#Reemplaza lo pedido y devuelve el resultado en el archivo codigo_secreto.txt
reemplazo=$(sed 's/[129]/X/g' $1 | sed 's/[08]/_/g')
echo "$reemplazo" > codigo_secreto.txt
