# find .        Busca en el directorio actual.
# -name "*"     Busca todos los archivos
# -type         de tipo 
# f             file
# d             directory
# |             pipe
# sort -n -r    ordena los archivos con opcion -n -r
# while read    mientras lea todos los parametros que encuentra find, hace lo posterior.

# renombrando primero archivos

find . -name "*" -type f | sort -n -r | while read all_files    
    do
        echo "Primero renombraremos archivos"
        echo "archivos sin espacios, guiones bajos y de mayusculas a minisculas"
        files_procesados=`echo $all_files | tr ' ' '-' | tr '_' '-' | tr '[A-Z]' '[a-z]'`
        
				if [ $files_procesados == $all_files ]
        	then
            	echo "$CYAN $all_files ya esta procesado ... sin cambios"
        	else
            	mv "$all_files" "$files_procesados"
            	echo "renombrando archivo: $VERDE $all_files a $ROJO $files_procesados"
        fi
    done

# renombrando despues directorios

find . -name "*" -type d | sort -n -r | while read all_dirs    
    do
        dirs_procesados=`echo $all_dirs | tr ' ' '-' | tr '_' '-' | tr '[a-z]' '[A-Z]'`
        if [ $dirs_procesados == $all_dirs ]
        	then
          	echo "directorio: $CYAN $all_dirs ya esta procesado ... sin cambios"
        	else
            mv "$all_dirs" "$dirs_procesados"
            echo "renombrando Directorio: $VERDE $all_dirs a $ROJO $dir_procesados"
        fi
    done
