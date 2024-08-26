insert_into_table(){
    db_name=$1
    
    read -p "Enter table name: " table_name ;
    path="./databases/$db_name/$table_name"

# check if the file exist
    if [[ ! -e "$path.txt" ]]; then
        echo "Table does not exist"
        return
    fi

# get the header data and store it into an associative array
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
echo "column and type pairs from the table: "
header_text=""
for key in ${order[@]};do
     header_text+="$key: ${header_array[$key]} | "
done
echo $header_text

# Data Validation 

# get the rows data
row_data=""
for key in ${order[@]};do
  read -p "Enter the $key: " data
  row_data+="$data:"
done
#remove the last character which is `:` and save it to the file
row_data=${row_data::-1}
echo $row_data >> "$path.txt"

echo "row inserted successfully"

}


insert_into_table b