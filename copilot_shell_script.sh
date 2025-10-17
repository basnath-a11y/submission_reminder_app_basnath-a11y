#!/bin/bash

app_dir="submission_remainder_*/"
startup_file="startup.sh"
config_file="./submission_remainder_*/config/config.env"
continue_check="y"
user_assignment="" # Holds the user's input

copilot_check() {
    # The assignment name is passed as the first argument
    assignment="$1"

    if [ ! -d $app_dir ]; then
        sleep 0.9
        echo "The directory doesn't exist. Please run the file create_environment.sh"
        echo " "
        exit 1
    else
        sed -i "s/ASSIGNMENT=\".*\"/ASSIGNMENT=\"$assignment\"/" $config_file

        echo "Processing '$assignment' assignment"

        cd $app_dir
        if [ ! -f $startup_file ]; then
            echo "Error: $startup_file not found."
            exit 1
        else
            ./$startup_file
            cd ..
        fi
    fi
}

while [[ "$continue_check" == "y" || "$continue_check" == "Y" ]]; do
    echo " "
    echo "Which assignment do you want to check?"
    echo "Example options:
Shell Navigation
Shell Basics
Git"

    # Read the assignment name directly into user_assignment
    read -p "Enter the assignment name: " user_assignment

    # Call the function, passing the name the user typed
    copilot_check "$user_assignment"

    echo " "
    read -p "Do you want to analyze another assignment (y/n): " continue_check
done

echo -e "Exiting"

