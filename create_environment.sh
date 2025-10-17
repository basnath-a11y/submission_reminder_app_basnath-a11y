#!/usr/bin/bash

#When the script runs, it should prompt the user for their name and create a directory named submission_reminder_{yourName}, replacing {yourName} With the input.

read -p "Enter your name: " Username
#make the directory called submission_remainder_{yourname} as well as the subdirectories with their contents

parent_dir="submission_remainder_${Username}"
mkdir -p "$parent_dir"

#create subdirectories
mkdir -p "$parent_dir/app"
mkdir -p "$parent_dir/modules"
mkdir -p "$parent_dir/assets"
mkdir -p "$parent_dir/config"

#creating the files and their contents

app="$parent_dir/app"
modules="$parent_dir/modules"
assets="$parent_dir/assets"
config="$parent_dir/config"

#create config.env and its content
cat > "$config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#create reminder.sh and its content
cat > "$app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="$(dirname "$0")/../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#create functions.sh and its contents
cat > "$modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#create submissions.txt and its contents
cat > "$assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Mwiti, Git, submitted
Musando, Git, not submitted
Yvonne, Shell Navigation, not submitted
Antoinne, shell Basics, submitted
Stephen, Shell Navigation, not submitted
Michael, Git, not submitted
Richard, Shell Basics, submitted
EOF

cat > "$parent_dir/startup.sh" << 'EOF'
#!/bin/bash

# Get absolute path of this script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to reminder.sh
reminder_script="$script_dir/app/reminder.sh"

# Check if config file exists
if [ ! -f "$script_dir/config/config.env" ]; then
    echo "Error: config.env not found. Please run this script from inside $script_dir"
    exit 1
fi

# Launch the reminder app
bash "$reminder_script"

EOF

#Give .sh files excecution permissions
chmod +x $app/*
chmod +x $modules/*
cd $parent_dir
chmod +x startup.sh
cd ..


echo "wow! Environment has been created successfully"
echo "To test the application run:"
echo "cd $parent_dir && ./startup.sh"
