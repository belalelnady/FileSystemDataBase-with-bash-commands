# Global Variables
#get the db_name from sourcing
db_name=$1
table_name="" 

update_word_rows(){
    read -p "Enter the word you want to update in the Rows: " old_word ; 
    read -p "Enter the new word: " new_word ; 
    #/g for global (all)
    sed -i "s/$old_word/$new_word/g" "./databases/$db_name/$table_name.txt"
    echo "Updated ( $old_word )to ( $new_word ) "
}

# update_row(){

# }
update_in_column(){

#----------Select the Column----------------------------
    echo "Header names : ${order[@]}"
    read -p "Enter the Column name: " input
    header_number=""

    # Loop through the header list adn get the matching column number 
    for ((i = 0 ; i<= ${#order[@]} ; i++))
    do
        if [[ ${order[$i]} != $input ]]; then
        continue
        else
            echo  ${order[$i]}
            header_number=$(($i+1))
        fi
    done
    #  no match for header name  
    if [[ -z $header_number ]]; then
        echo "This header doesn't exist"
         return
    fi
    # add the column to a temp file
    awk -F: -v col=$header_number '{ print $col }' ./databases/$db_name/$table_name.txt  
  


}



   

#To-Do ----------------------------
# update_with_row_number(){

# }

update_table(){
    
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
        echo "1. Update a Word in Rows "
        echo "2. Update a Row"
        echo "3. Update Column"
        echo "4. Back"
        echo "--------------------------------"
        read -p "Enter your choice number: " choice_number

        case "$choice_number" in
            1) update_word_rows ;;
            2) update_row ;;
            3) update_in_column;;
            4) break ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    done

}


update_table 