#!/bin/bash

#En esta expresion cambio todas las mayusculas por minusculas, y elimino todos los caracteres excepto las minusculas, y solo me queda el mensaje oculto
encontrar_codigo=$(sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' $1 | sed s/'[^a-z]'/""/g)

#Imprime el codigo encontrado en el archivo mensaje_papiro.txt
escribir_papiro(){
for i in $encontrar_codigo; do 
	echo -n "$i" >> mensaje_papiro.txt
done
}
escribir_papiro

#Descifra el codigo reemplazando las palabras dadas
mensaje_decodificado=$(sed 's/cueva/doblar/g' < mensaje_papiro.txt  | sed 's/secreta/izquierda/g' | sed 's/pocos/despues/g' | sed 's/metros/derecha/g' | sed 's/arriba/delante/g' | sed 's/atras/reversa/g')

#Guarda el mensaje decodificado en dos archivos distintos y simultaneamente
echo "$mensaje_decodificado" | tee mensaje_papiro.txt backup_mensaje.txt
 