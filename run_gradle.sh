#!/bin/bash

# List of directories where you want to run gradle clean bootJar
dirs=(
    "./auth-service"
    "./stock-service"
    "./portfolio-service"
)

# Loop through each directory and run gradle clean bootJar
for dir in "${dirs[@]}"; do
    echo "Running gradle clean bootJar in $dir"
    cd "$dir" || { echo "Failed to navigate to $dir"; exit 1; }

    # Check if gradle wrapper exists, if not use gradle command directly
    if [ -f "./gradlew" ]; then
        ./gradlew clean bootJar
    else
        gradle clean bootJar
    fi

    # Check if the command ran successfully
    if [ $? -eq 0 ]; then
        echo "Build successful in $dir"
    else
        echo "Build failed in $dir"
        exit 1
    fi

    cd ..
done

echo "All builds completed."
