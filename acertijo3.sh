#!/bin/bash

infactores=$1
obtener_nombres=$(grep -oP '[a-zA-Z]+\s[a-zA-Z]+' $1)
obtener_fechas=$(grep -oP '[0-9\/]{10}' $1)
obtener_tiempos=$(grep -oP '[0-9]+$' $1)
obtener_anios=$(grep -oP '(?<=[/])[0-9]{4}' $1)
todo=$(grep -E '[a-z]' $1)

declare -a array_nombres
while read -r nombre; do
	array_nombres+=("$nombre")
done <<< "$obtener_nombres"

declare -a array_fechas
while read -r fecha; do
    array_fechas+=("$fecha")
done <<< "$obtener_fechas"

declare -a array_tiempos
while read -r tiempo; do
	array_tiempos+=("$tiempo")
done <<< "$obtener_tiempos"

declare -a array_anios
while read -r anio; do
    array_anios+=("$anio")
done <<< "$obtener_anios"

#Esta funcion simplemente mueve los datos desde la posicion j+1 hasta la posicion j, utilizando una variable temporal como tercero para manipular los datos correctamente.
acomodar_arrays(){

    variable_temp="${array_nombres[$j]}"
    array_nombres[$j]="${array_nombres[$(($j + 1))]}"
    array_nombres[$(($j + 1))]="$variable_temp"

    variable_temp="${array_fechas[$j]}"
    array_fechas[$j]="${array_fechas[$(($j + 1))]}"
    array_fechas[$(($j +1))]="$variable_temp"

    variable_temp="${array_tiempos[$j]}"
    array_tiempos[$j]="${array_tiempos[$(($j + 1))]}"
    array_tiempos[$(($j + 1))]="$variable_temp"

    variable_temp="${array_anios[$j]}"
    array_anios[$j]="${array_anios[$(($j + 1))]}"
    array_anios[$(($j + 1))]="$variable_temp"            

}

#Esta funcion ordena con el metodo de la burbuja, es decir, va comparando en parejas, en todas las posiciones, luego si encuentra una posicion mayor a la otra llama a la funcion que se encarga de mover los datos
ordenar_por_anio_y_tiempo(){
    cant_fechas="${#array_fechas[@]}"
    for ((i=0;i<$cant_fechas-1;i++)); do
        for ((j=0;j<$cant_fechas-i-1;j++)); do

    	   anio_j="${array_anios[$j]}"
    	   anio_j1="${array_anios[$(($j + 1))]}"

    	    if [ "$anio_j" -gt "$anio_j1" ]; then
                acomodar_arrays $j	      
            fi

            if [[ "$anio_j" -eq "$anio_j1" && "${array_tiempos[$j]}" -gt "${array_tiempos[$(($j+1))]}" ]]; then
                acomodar_arrays $j
            fi
        done
    done
    compactar_linea_completa "$cant_fechas"
}

compactar_linea_completa(){
    cant_fechas=$1
    declare -g -a array_linea_completa
    h=0
    while [ $h -lt $cant_fechas ]; do
	   array_linea_completa+=("${array_nombres[$h]}","${array_fechas[$h]}","${array_tiempos[$h]}")
	   ((h++))
    done
}


#Esta funcion empieza con declarando las variables anio inicial y m, ya que en el ciclo while manipulo las primeras 3 lineas del archivo, que van a estar ordenadas, por lo tanto seria el primer anio, luego voy manipulando los demas anios sumandole uno a la variable anio_inicial, con el segundo for me encargo de solo tomar las primeras 3 lineas del año correspondiente
generador_archivo_infractores(){
    anio_inicial=2020
    m=0
    for((k=0;k<=cant_fechas-1;k++)); do
	   while [ $m -lt 3 ]; do
		  echo "${array_linea_completa[$m]}" >> infractores.txt
		  ((m+=1))
	    done
	    if [ "${array_anios[$k]}" -eq "$anio_inicial" ]; then
	         for((l=$k;l<$k+3;l++)); do
				echo "${array_linea_completa[$l]}" >> infractores.txt
			done
			((anio_inicial+=1))
		fi
done
}

#Esta funcion utiliza  el mismo metodo de ordenamiento que la anterior, buble sort, solamente que comparo los mejores tiempos y ordeno todas las lineas por tiempo, para luego tomar las primeras 3
ordenar_por_tiempo(){
    for ((i=0;i<$cant_fechas-1;i++)); do
        for ((j=0;j<$cant_fechas-i-1;j++)); do

    	   tiempo_j="${array_tiempos[$j]}"
    	   tiempo_j1="${array_tiempos[$(($j + 1))]}"

    	   if [ "$tiempo_j" -gt "$tiempo_j1" ]; then

   			    variable_temp="${array_linea_completa[$j]}"
                array_linea_completa[$j]="${array_linea_completa[$(($j + 1))]}"
                array_linea_completa[$(($j + 1))]="$variable_temp"

                variable_temp="${array_tiempos[$j]}"
                array_tiempos[$j]="${array_tiempos[$(($j + 1))]}"
                array_tiempos[$(($j + 1))]="$variable_temp"
            fi
        done
    done
}
#con esta funcion genero el archivo tomando las primeras 3 lineas del array_linea_completa
generador_archivo_acertijo3(){
for((i=0;i<3;i++)); do
	echo "${array_linea_completa[$i]}" >> acertijo3.txt
done
}

ordenar_por_anio_y_tiempo
generador_archivo_infractores
ordenar_por_tiempo
generador_archivo_acertijo3