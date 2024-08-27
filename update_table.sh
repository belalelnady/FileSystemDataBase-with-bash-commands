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
#-------------- add the column to a temp file-------------------
    #get rows number
    rows_number=$(awk -F: -v col=$header_number 'END { print NR }' ./databases/$db_name/$table_name.txt)
    #var of the path to the temp column file
    column_file="./databases/$db_name/$table_name.temp"

    echo $rows_number
    # storing the cell data
    for (( i=1; i<=$rows_number; i++ )); do
         read -p "Enter the cell nmber $i value: " input
         echo $input >> "$column_file"
    done 
# ------------------------save the data to array to edit and then again to the file

            # Read each line into an array
            mapfile -t new_column < "$column_file"

            # Print the array to verify
            echo "Values Array:"
            echo "|${new_column[@]} |"


            # Initialize an empty 2D array
            declare -A myArray
            #number of headers
            num_columns=${#order[@]}

            # read each line from the file into a 1D array
            #-t option removes the newline characters.
            mapfile -t lines < ./databases/$db_name/$table_name.txt

            # add the values to the 2D array with lines-array to change each one seperately
            for i in "${!lines[@]}"; do
                #-a fields tells read to split the input into an array named fields.
                IFS=':' read -r -a fields <<< "${lines[$i]}"

                for (( col=0; col<num_columns; col++ )); do
                    myArray[$i,$col]=${fields[$col]}
                done
            done

            # REPlace a row with array
            # new_row=("7" "newname" "newgroup" "newnone")
            # row_number=1
            # # Replace the second row (index 1)
            # for col in "${!new_row[@]}"; do
            #     myArray[$row_number,$col]=${new_row[$col]}
            # done


            # Column to replaced
            column_to_replace=$(($header_number-1))

            # Replace the specified column with values from the column array
            for (( i=0; i<${#new_column[@]}; i++ )); do
                myArray[$i,$column_to_replace]=${new_column[$i]}
            done

            # File to save the updated data
            output_file="./databases/b/updated_data.txt"

            # Write the updated 2D array to the file
            for (( i=0; i<${#lines[@]}; i++ )); do
                row=""
                for (( col=0; col<$num_columns; col++ )); do
                    row+="${myArray[$i,$col]}"
                    if [[ $col -lt $(($num_columns-1)) ]]; then
                     
                        row+=":"
                    fi
                done
                echo "$row" >> "$output_file"
            done
            # move the new data  to the tablefile
            mv $output_file ./databases/$db_name/$table_name.txt
            rm "$column_file"

            
            # echo "Updated 2D Array:"
            # for (( i=0; i<${#lines[@]}; i++ )); do
            #     echo "${myArray[$i,0]} ${myArray[$i,1]} ${myArray[$i,2]} ${myArray[$i,3]}"
            # done





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
        echo "2. Update Column"
        echo "3. Back"
        echo "--------------------------------"
        read -p "Enter your choice number: " choice_number

        case "$choice_number" in
            1) update_word_rows ;;
            2) update_in_column;;
            3) break ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    done

}


update_table 