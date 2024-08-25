#!/bin/bash


# connect to DB by passing the DB name
connect_to_database() {
    # argument_1
    db_name="$1"
 
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
            1) read -p "Enter table name: " table_name ; touch ./databases/$db_name/$table_name.txt ;;
            2) echo "available tables : $(ls ./databases/$db_name)" ;;
            3) read -p "Enter table name to delete it: " table_name ; rm  ./databases/$db_name/$table_name.txt ;;
            8) break ;;
            *) echo "Invalid input. Try again" ;;
        esac


    done
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
        1) read -p "Enter database name: " db_name && mkdir -p ./databases/$db_name ;;
        2) ls ./databases ;;
        3) read -p "Enter database name to connect : " db_name; connect_to_database $db_name ;;
        4) read -p "Enter database name to be deleted : " db_name; rm -rf "./databases/$db_name";; 
        5) exit ;;
        *) echo "Invalid choice. Try again." ;;
    esac
done
