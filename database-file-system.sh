#!/bin/bash

# Create table with column name and type 
create_table(){
    # get the name of the DB as an arument 
    db_name=$1

    # get the table name and store it
    read -p "Enter table name: " table_name ; 
    touch ./databases/$db_name/$table_name.txt  ./databases/$db_name/$table_name.meta;

    # declare a key value array (associative)
    declare -A table_head_array

    echo "Enter key-value pairs for the table column heads (column name : column value), seperated by colon : one per line. Type 'done' when finished: "
    while true; do
        read name_type
        # conndition to break
        if [[ $name_type == "done" ]]; then
            break
        fi
        
        # Split the input by the colon : and store it in key and value as variables 
        # <<<: Passes a string as input to read.
        IFS=":" read -r key_name value_type <<< "$name_type"
        
        # Store the key-value pair in an associative array
        table_head_array["$key_name"]="$value_type"
    done


   # Store the values in the meta file
    for key in "${!table_head_array[@]}"; do
        echo "$key: ${table_head_array[$key]}" >> ./databases/$db_name/$table_name.meta
    done
    echo "Your table has been created successfully"

}

drop_table(){
    db_name=$1
    read -p "Enter table name to delete it: " table_name ;
    path="./databases/$db_name/$table_name"

    # check if the file exist
    if [[ -e "$path.txt" ]]; then
        rm  "$path.txt" ;
        rm  "$path.meta" ;
        echo "Table has been deleted."
    else  
         echo "Table does not exist"
    fi
}

insert_into_table(){
    db_name=$1
    read -p "Enter table name: " table_name ;
    path="./databases/$db_name/$table_name"

    # check if the file exist
    if [[ ! -e "$path.txt" ]]; then
        echo "Table does not exist"
        return
    fi

}
# connect to DB by passing the DB name
connect_to_database() {
    read -p "Enter database name to connect : " db_name;

    echo "Connected to $db_name"
    while true; do
        echo "1. Create Table"
        echo "2. List Tables"
        echo "3. Drop Table"
        echo "4. Insert into Table"
        echo "5. Select From Table"
        echo "6. Delete From Table"
        echo "7. Update Table"
        echo "8. Disconnect"
        read -p "Enter your choice number: " choice_number

        case "$choice_number" in
            1) create_table $db_name;;
            2) echo "available tables : $(ls ./databases/$db_name)" ;;
            3) drop_table $db_name;;
            4) insert_into_table $db_name ;;
            8) break ;;
            *) echo "Invalid input. Try again" ;;
        esac


    done
 }


create_database(){
    read -p "Enter database name: " db_name ;

    # check if the directory exist
    if [[ -d "./databases/$db_name" ]]; then
        echo "Database $db_name already exists"
        return
    fi
    mkdir -p ./databases/$db_name  ;
    mkdir -p ./databases/$db_name/.meta  ;
    echo "Database $db_name Created successfully" 

}

drop_database(){
    read -p "Enter database name to be deleted : " db_name;
  

     # check if the directory exist
    if [[ -d "./databases/$db_name" ]]; then
        rm -rf "./databases/$db_name"
        echo "Database $db_name deleted"
    else
        echo "Database $db_name doesn't exist"
    fi

}
# Main menu
while true; do
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect To Databases"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter your choice number: " choice_number

    case "$choice_number" in
        1) create_database ;;
        2) ls ./databases ;;
        3) connect_to_database ;;
        4) drop_database;; 
        5) exit ;;
        *) echo "Invalid choice. Try again." ;;
    esac
done
