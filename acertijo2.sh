#!/bin/bash


#Primero comienzo eliminando o sustituyendo las expresiones pedidas
letra_horrenda=$(sed -r '/^[A-Z][a-z]/!d' $1 | sed -r '/[aeiou]{3,}/d' | sed -r '/[0-9]/d' | sed 's/[aeiou]/X/g')


#Esta funcion va sumando en el contador de palabras dependiendo de cuantos elementos tenga el verso, esta funcion es llamada con un argumento el cual es el indice del slicing en array_versos
contador_palabras(){
	contador_palabras=0
	for palabra in ${array_versos[$1]}; do 
		((contador_palabras+=1))
	done
	echo "$contador_palabras"	
}

#Esta funcion declara el array de palabras y le va agregando al mismo cada una en una posicion distinta para trabajar de manera mas comoda, recibe el mismo argumento que la anterior, ya que trabajan con el mismo verso
creador_array_palabras(){
	declare -g -a array_palabras=()
	for palabra in ${array_versos[$1]}; do 
		array_palabras+=("$palabra ")
	done
	echo "${array_palabras[@]}"	
}


#Esta funcion recibe dos argumentos, el valor de contador_palabras y el array de palabras, ambas relacionadas y trabajan en conjunto, primero declaro otro array llamado verso_invertido, que es donde voy a guardar en el final el verso completo e invertido, luego inicio un ciclo for con la variable igualada a la cantidad de palabras - 1, ya que debo tomar el indice 0, dentro de ese ciclo declaro: el array palabra_invertir, donde voy a guardar desde la ultima palabra hasta la primera; el contador de letras; y la variable vacia palabra_invertida, donde se guardara la palabra ya invertida, todo dentro del ciclo for ya que cuando cambie de palabra tiene que volver a hacer el mismo proceso, luego dentro de otro for donde la variable "k" se inicia con el contador_letras-2, le resto 2 para que no tome en cuenta un espacio en blanco y para hacer slicing correctamente, y luego a la palabra_invertida se le van agregando las letras desde la ultima hasta la primera, cuando termina el ciclo se agrega al array verso_invertido creado al principio
invertir_palabras_versos(){

	local contador_palabras=$2
	declare -a verso_invertido=()

	for((j=$(($contador_palabras - 1));j>=0;j--)); do

		declare -a palabra_invertir=()
		palabra_invertir+=("${array_palabras[$j]}")
		contador_letras=${#palabra_invertir}
		palabra_invertida=""
		
		for((k=$((contador_letras-2));k>=0;k--)); do
			palabra_invertida+="${palabra_invertir:$k:1}"
		done
		verso_invertido+="$palabra_invertida"
	done
	echo "$verso_invertido" >> venganza.txt
}



#Esta funcion es el bloque principal donde declaro el contador de versos el array_versos y leo linea por linea guardando cada una, luego inicio el ciclo for con la variable i inicializada en 0 mientras sea menor al contador de versos , luego con el condicional if si el contador palabra es menor que 5 llama a la funcion invertir palabras y versos pasandole como argumentos el array de palabras obtenido en la funcion creador_array_palabras y el contador de palabras obtenido en su respectiva funcion, luego si el contador de palabras es mayor a 5 el verso se guarda en el archivo venganza.txt
procesar_versos(){

	contador_versos=0
	declare -a array_versos
	while read -r lineas; do
		array_versos+=("$lineas")
		((contador_versos+=1))
	done <<< "$letra_horrenda"

	for((i=0;i<$contador_versos;i++)); do

		contador_palabras=$(contador_palabras $i)
		array_palabras=$(creador_array_palabras $i)
		
		if [ "$contador_palabras" -lt 5 ]; then
			invertir_palabras_versos "${array_palabras[@]}" "$contador_palabras"

		else
			echo "${array_versos[$i]}" >> venganza.txt

		fi
	done
}

procesar_versos