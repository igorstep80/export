for folder in /mnt/db/*/; do
    # Extract the folder name
    folder_name=$(basename "$folder")

    # Prepare container names
    container_name="$folder_name"
    e_container_name="e$folder_name"

    # Function to stop containers with retry logic
    stop_containers() {
        attempts=0
        max_attempts=10
        while [ $attempts -lt $max_attempts ]; do
            docker stop "$e_container_name" "$container_name" && break
            attempts=$((attempts + 1))
            echo "Retrying to stop containers: $e_container_name $container_name (Attempt $attempts/$max_attempts)"
            sleep 10  # Adding a short delay before retrying
        done

        if [ $attempts -eq $max_attempts ]; then
            echo "Failed to stop containers: $e_container_name $container_name after $max_attempts attempts."
            exit 1  # Exit the script if it fails after the max attempts
        fi
    }

    # Stop the containers with retry
    stop_containers

    # Run the repair script
    find "$folder" -type f -name "*.db" -exec ./repair.sh {} \;

    # Start the containers
    docker start "$container_name" "$e_container_name"
done
