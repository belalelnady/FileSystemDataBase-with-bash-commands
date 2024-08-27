#!/bin/bash

  awk -F: -v col=1 'END { print NR }' ./databases/b/v.txt  > ./databases/b/v.temp

# GET THE COLUMN VALUE FOM THE FILE
column_file="./databases/b/v.temp"

# Read each line into an array
mapfile -t new_column < "$column_file"

# Print the array to verify
echo "Names Array:"
echo ${new_column[@]}


# Initialize an empty 2D array
declare -A array

# Read each line from the file into a 1D array
#-t option removes the newline characters.
mapfile -t lines < ./databases/b/v.txt

# Populate the 2D array with lines array
for i in "${!lines[@]}"; do
    IFS=':' read -r -a fields <<< "${lines[$i]}"
    array[$i,0]=${fields[0]}
    array[$i,1]=${fields[1]}
    array[$i,2]=${fields[2]}
    array[$i,3]=${fields[3]}
done

# REPlace a row with array
# new_row=("7" "newname" "newgroup" "newnone")

# # Replace the second row (index 1)
# for col in "${!new_row[@]}"; do
#     array[1,$col]=${new_row[$col]}
# done


# Column to replace
column_to_replace=3

# Replace the specified column with values from the column array
for (( i=0; i<${#new_column[@]}; i++ )); do
    array[$i,$column_to_replace]=${new_column[$i]}
done

# File to save the updated data
output_file="./databases/b/updated_data.txt"

# Write the updated 2D array to the file
for (( i=0; i<${#lines[@]}; i++ )); do
    row=""
    for (( col=0; col<4; col++ )); do
        row+="${array[$i,$col]}"
        if [[ $col -lt 3 ]]; then
            row+=":"
        fi
    done
    echo "$row" >> "$output_file"
done

mv $output_file ./databases/b/v.txt

# Print the 2D array to verify
echo "Updated 2D Array:"
for (( i=0; i<${#lines[@]}; i++ )); do
    echo "${array[$i,0]} ${array[$i,1]} ${array[$i,2]} ${array[$i,3]}"
done

echo "Data has been saved to $output_file"
