 # Define a Bash array
my_array=("one" "two" "three")

# Convert array to a space-separated string
array_string=$(printf "%s " "${my_array[@]}")

# Use awk to process the array elements
echo "$array_string" | awk '{
    for (i=1; i<=NF; i++) print $i
    
    }'


