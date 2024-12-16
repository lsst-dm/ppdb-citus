#!/usr/bin/env bash

# Usage:
#   ./import_csv.sh TABLE_NAME PATH_TO_CSV_FILE

# Check for required arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 TABLE_NAME PATH_TO_CSV_FILE"
    exit 1
fi

TABLE_NAME="$1"
CSV_FILE="$2"

# Database URL
DBURL="${DBURL:-postgresql://postgres@localhost:5432/ppdb}"

# Schema name
SCHEMA="ppdb_test1"

# Check if CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: CSV file '$CSV_FILE' does not exist."
    exit 1
fi

echo "Importing '$CSV_FILE' into table '$SCHEMA.$TABLE_NAME'..."

# Execute the \copy command with schema set
psql "$DBURL" <<EOF
SET search_path TO "$SCHEMA", public;
\copy "$TABLE_NAME" FROM '$CSV_FILE' WITH (FORMAT csv, HEADER);
EOF

# Check if the import was successful
if [ $? -eq 0 ]; then
    echo "Successfully imported '$CSV_FILE' into '$SCHEMA.$TABLE_NAME'."
else
    echo "Failed to import '$CSV_FILE' into '$SCHEMA.$TABLE_NAME'."
    exit 1
fi

