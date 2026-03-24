#!/bin/bash

#exportamos FILENAME como una variable de ambiente dentro del script
export FILENAME="FILENAME"

#planeamos que si el usuario escribe el parametro -d ejecutando el script, se haga una limpieza de entorno y se 
#finalice el proceso en background
if [[ "$1" == "-d" ]]; then
    echo "Ejecutando limpieza del entorno..."
    pkill -f consolidar.sh 
    rm -rf "$HOME/EPNro1"
    echo "Entorno eliminado y procesos finalizados."
    exit 0
fi

#Guardo la ruta de FILENAME.txt
ruta_archivo="$HOME/EPNro1/salida/$FILENAME.txt"
opcion=0
contador=0

#hacemos un bucle para que el menu finalice unicamente cuando el usuario presione la tecla 6
while [[ "$opcion" != "6" ]]; do
if [[ $contador != 0 ]]; then
	echo -e "\nPresione cualquier tecla para continuar\c"
	read -n 1 -s
	clear
fi

echo -e "\n+++++MENU+++++
1) Crear entorno 
2) Correr Proceso
3) Lista alumnos ordenados por numero de padron
4) Mostrar las 10 notas mas altas del listado
5) Buscar alumno por numero de padron
6) Salir\n
Elija una opcion: \c"
read opcion

case $opcion in
1)
        mkdir -p "$HOME/EPNro1/entrada"  
        mkdir -p "$HOME/EPNro1/procesado"
        mkdir -p "$HOME/EPNro1/salida"

echo '#!/bin/bash
ruta_procesado="$HOME/EPNro1/procesado"
ruta_salida="$HOME/EPNro1/salida/$FILENAME.txt"
ruta_entrada="$HOME/EPNro1/entrada"

while true; do 
	for archivo in "$ruta_entrada"/*.txt; do
        	if [[ -f "$archivo" ]]; then
            		cat "$archivo" >> "$ruta_salida"
            		mv "$archivo" "$ruta_procesado"
        	fi
	done
sleep 2
done' > "$HOME/EPNro1/consolidar.sh"

#le damos permisos a consolidar.sh (sino nos da error por permisos)
chmod +x "$HOME/EPNro1/consolidar.sh"        
	echo -e "El entorno creado y consolidar.sh generado en /HOME/EPNro1 \n"
;; 

2)
	 if [[ -d "$HOME/EPNro1/entrada" ]]; then
		"$HOME/EPNro1/consolidar.sh" &
		echo "Se ejecuto el proceso en background"
	else
                echo "aun no se creo el entorno (no se encuentra la carpeta entrada)"
        fi
;;
  
3)
        if [[ -f "$ruta_archivo" ]]; then
                sort -nk1 "$ruta_archivo" -o "$ruta_archivo"
                cat "$ruta_archivo" 
        else
                echo "Aun no se creo el entorno que contiene la carpeta salida o no hay archivos dentro"
        fi
;;

4)
        if [[ -f "$ruta_archivo" ]]; then
                sort -nrk5 $ruta_archivo -o "$ruta_archivo"
		cat "$ruta_archivo" | head -n 10
	else
                echo "Aun no se creo el entorno que contiene la carpeta salida o no hay archivos dentro"
        fi  
;;

5)
	echo -e "Escriba un numero de padron: \c"
	read padron_seleccionado
	if [[ -z "$padron_seleccionado" || "$padron_seleccionado" == *[!0-9]* ]]; then
		echo "Utilice valores numericos"
	else 
		if grep -q "$padron_seleccionado" "$ruta_archivo"; then
			grep "$padron_seleccionado" "$ruta_archivo"
		else
			echo "No figura ese padron en la lista"
		fi
	fi	
;;

6)
	pkill -f consolidar.sh
	clear
;;

esac
((contador++))
done
clear
echo -e "\nSALISTE DEL MENU\n"
