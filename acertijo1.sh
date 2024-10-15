#!/bin/bash



#En este bloque obtengo las expresiones que necesito para trabajar, extraje los minutos para poder analizarlos mas comodamente al final del codigo
registro=$1
horarios=$(grep -oP '[(0-23):(0-59)]{5}+(?=[\s])' registro.txt)
subsuelo=$(grep -oP '(?<=[\s])[0-7]+(?=[\s])' registro.txt)
accion=$(grep -oP '(?<=[\s])[a-zA-Z"áéíóúñ\s]+' registro.txt | sed '/^\s*$/d')
minutos=$(grep -oP '(?<=[:])[0-9]+' registro.txt)

#Declaro las listas y variables que voy a usar que voy a usar 
declarar_listas(){
	declare -a array_acciones
	declare -a array_horarios
	declare -a array_subsuelo
	declare -a array_minutos
	subsala=7

}


#En esta funcion le paso los componentes linea a linea a los array para trabajar con slicing 
componer_listas(){
	while read -r accion_pato; do
    	array_acciones+=("$accion_pato")
	done <<< "$accion"

	while read -r pisos; do
    	array_subsuelo+=("$pisos")
	done <<< "$subsuelo"

	while read -r horas; do
    	array_horarios+=("$horas")
	done <<< "$horarios"

	while read -r minuto; do
		array_minutos+=("$minuto")
	done <<< "$minutos"
}

#En esta funcion, declaro la variable i, para iterarla en el while mientras sea menor a la cantidad de acciones de pato, luego se declarar las sentencias de control para verificar los datos pedidos por el ejercicio, si cumplen las 3 sentencias se genera el archivo, y la variable i pasa a valer 100, esto para finalizar el bucle while.
encontrar_pato(){
	i=0
	while [ "$i" -lt ${#array_acciones} ]; do
		if [[ "${array_acciones[$i]}" == "se resbaló en el barro" || "${array_acciones[$i]}" == "se limpió las pezuñas" ]]; then
			if [ ${array_subsuelo[$i]} -eq $subsala ]; then
				if [ $((${array_minutos[$i]} % 2)) -ne 0 ]; then
					echo "Hora indicada para capturar a Pato: ${array_horarios[$i]}" > pato.txt
					i=100
				fi
			fi	
		fi
		i+=1
	done
}

declarar_listas
componer_listas
encontrar_pato