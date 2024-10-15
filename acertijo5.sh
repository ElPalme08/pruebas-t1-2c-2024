#!/bin/bash


apariciones_misterio=$(grep -oP 'misterio(?=[\s])' $1)

#Crea una variable y la utiliza en el ciclo for para guardar la cantidad de veces que aparece la palabra misterio
contador_misterio(){
contador=0
for i in $apariciones_misterio; do
	((contador+=1))
done
echo "La palabra misterio aparece $contador veces" > lector_clave_secreta.txt
}

#Calcula el factorial de un numero, toma casos borde por si el numero es negativo o cero
funcion_factorial(){
	if [ $1 -gt 0 ]; then
		variable=1
		for (( i=1;i<=$1;i++ )); do
			variable=$(($variable * $i))
		done
		echo "el factorial de $1 es $variable" >> lector_clave_secreta.txt
	elif [ $1 -eq 0 ]; then
		echo "el factorial de 0 es 1" >> lector_clave_secreta.txt
	else
		echo "el factorial de un numero negativo es 0" >> lector_clave_secreta.txt
	fi
}

#Calcula el fibonacci de el parametro dado, toma casos como un numero negativo, o el numero 1 
funcion_fibonacci(){
	if [ "$1" -le 0 ]; then
        echo "el fibonacci de un numero negativo es 0" >> lector_clave_secreta.txt
    elif [ "$1" -eq 1 ]; then
        echo "el fibonacci de 1 es 1" >> lector_clave_secreta.txt
    else
        a=0
        b=1
        for ((i=2; i<=$1; i++)); do
            temp=$b
            b=$(($a + $b))
            a=$temp
        done
        echo "el fibonacci de $1 es $b" >> lector_clave_secreta.txt
    fi
}

#Organiza el programa principal, recibiendo el parametro y procesando si es par o impar.
funcion_principal(){
	if [ $(($1 % 2)) -eq 0 ]; then
		funcion_factorial $1
	else
		funcion_fibonacci $1
	fi
}

contador_misterio $apariciones_misterio
funcion_principal $2