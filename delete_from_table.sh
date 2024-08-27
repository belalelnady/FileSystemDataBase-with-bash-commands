# Global Variables
#get the db_name from sourcing
db_name=$1
table_name=""

#To-Do
# -----------------Delete row with word------------------ 
delete_row_with_word(){
   
     read -p "Case Sensetive ?  y/n : " answer  
      read -p "Enter the word  : " word  
        case "$answer" in
            n)  sed -i "/$word/Id" ./databases/$db_name/$table_name.txt ;;
            y)  sed -i "/$word/d" ./databases/$db_name/$table_name.txt ;;
            *) echo "Invalid choice. Try again." ;;
        esac
   
   
    echo "Deleted"
}

# -------------------------Delete Row With Row Number -----------
delete_row_number(){
    read -p "Enter the row number to be deleted : " row_number

    # get numbers of rows
    table_rows_number=$(awk 'END { print NR }' ./databases/$db_name/$table_name.txt)
    if [[ $row_number -ge $table_rows_number ]]; then
        echo "Enter a valid value"
        return
    fi
   
    #-i Edits original file directly.
    sed -i "${row_number}d" ./databases/$db_name/$table_name.txt
    echo "Row has been deleted"

}
# --------------------Delete column --------------------
delete_column(){

    read -p "Enter the header name: " headerName
    header_number=""

    # Loop through the header list adn get the matching column number 
    for ((i = 0 ; i<= ${#order[@]} ; i++))
    do
        if [[ ${order[$i]} != $headerName ]]; then
        continue
        else
            header_number=$(($i+1))
        fi
    done
    #  no match for header name  
    if [[ -z $header_number ]]; then
        echo "This header doesn't exist"
        return
    fi
     echo $header_number
    # Delete column Meta data
    sed -i "/$headerName/d" ./databases/$db_name/.meta/$table_name.meta 

    # Deleting a column
    #selecting every thing  except the coulmn and cp it to a new file then rename
    awk -F: -v col="$header_number" '{
        for (i = 1; i <= NF; i++) {
             if (i == col) {
                printf ":"
             }
            if (i != col) {
                printf "%s", $i 
                
                if (i < NF && i != col - 1 ) {
                    printf ":"
                }
            }
        }
        printf "\n"
    }' ./databases/$db_name/$table_name.txt > ./databases/$db_name/$table_name.txt.tmp && mv ./databases/$db_name/$table_name.txt.tmp ./databases/$db_name/$table_name.txt

   

# -----TEST gone bad------
    # Deleting a column
    # declare -a column_holder
    # awk -F: -v col=$header_number '{ print $col }' ./databases/$db_name/$table_name.txt > ./databases/$db_name/temp.txt
 
    # while IFS= read -r line; do
    #     column_holder+=("$line")
    # done < ./databases/$db_name/temp.txt
    # rm  ./databases/$db_name/temp.txt
    # echo ${column_holder[@]}

    # iterate and replace every word with space
    # for word_to_delete in ${column_holder[@]}; do
    #     sed -i "s/\b${word_to_delete}\b//g" ./databases/$db_name/$table_name.txt
    # done

}




#Accept AWK command  
# ----------


delete_from_table(){

    # get table name
    read -p "Enter table name: " table_name ;
    path="./databases/$db_name/$table_name"

    # check if the file exist
    if [[ ! -e "$path.txt" ]]; then
        echo "Table does not exist"
        return
    fi  

    #--------------HEADER Data-------------------------------
    # For the header data (extract it to function later)
    declare -A header_array
    declare -a order
  
    # File containing key-value pairs
    header_file="./databases/$db_name/.meta/$table_name.meta"

    # Read the file line by line and store it in header_array
    while IFS=":" read -r key value; do
        # Store each key-value pair in the associative array
        header_array["$key"]=$value
        order+=("$key")
      
    done < $header_file
     # Display the header data
    header_text=""
    for key in ${order[@]};do
        header_text+="$key | "
    done


# ---------------------------------------


    # Select menu
    while true; do
        echo "--------------------------------"
        echo "1. Delete rows with a word "
        echo "2. Delete Row With row Number"
        echo "3. Delete Column with header name"
        echo "4. Back"
        echo "--------------------------------"
        read -p "Enter your choice number: " choice_number

        case "$choice_number" in
            1) delete_row_with_word ;;
            2) delete_row_number ;;
            3) delete_column ;;
            4) break ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    done


   
}

delete_from_table