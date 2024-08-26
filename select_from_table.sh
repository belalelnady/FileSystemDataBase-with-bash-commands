# Global Variables
#get the db_name from sourcing
db_name=$1
#table name from select_from_table
table_name=""


# --------------GEt HEADER DATA----------------


#To-Do  ----------------------------DONE----------------------
select_all() {
    echo $header_text
    # NF number of fields 
    awk -F: '{
    for (i=1; i<=NF; i++) { 
        printf "%s", $i
        printf " | "
            }
        printf "\n"
    }' ./databases/$db_name/$table_name.txt
}
# ---------------------------------DONE-----------------
# get_number_of_rows(){
#         # END is there to ONLY print the LAST action of the command
#          awk 'END { print "Number of rows is : " NR }' ./databases/$db_name/$table_name.txt
# }
# --------------Done-------

select_column_by_header_name(){
    echo ${order[@]}
    read -p "Enter the header name: " input
    
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
    fi
    # -v  define a variable and assign it a value before awk starts processing the input.
    awk -F: -v col=$header_number '{ print $col }' ./databases/$db_name/$table_name.txt
}
# --------------------------------------------------
select_by_row_number(){
    read -p "Enter row number :" row_number
    awk -v row="$row_number" 'NR == row' ./databases/$db_name/$table_name.txt
}
# -------------------DONE--------------
select_row_by_word(){
    read -p "Enter word name : " word
    grep -i  $word ./databases/$db_name/$table_name.txt
}
# --------------------------------------------------
#Accept AWK command  



select_from_table(){

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
        echo "1. Select All"
        echo "2. Select Column By Header Name"
        echo "3. Select By Row Number"
        echo "4. Select Row By Word"
        echo "5. Back"
        echo "--------------------------------"
        read -p "Enter your choice number: " choice_number

        case "$choice_number" in
            1) select_all ;;
            2) select_column_by_header_name ;;
            3) select_by_row_number ;;
            4) select_row_by_word;; 
            5) break ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    done


   
}

select_from_table