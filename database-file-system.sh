#!/bin/bash


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
        3) read -p "Enter database name: " db_name; connect_to_database $db_name ;;
        4) read -p "Enter database name: " db_name; rm -rf "./databases/$db_name";; 
        5) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
