# Function to prompt for username and domain
read_user_input() {
    read -p "Enter username: " username
    read -p "Enter domain: " domain
    email="$username@$domain"
}

# Function to execute the Docker command
add_email_to_mailserver() {
    docker exec -ti mailserver setup email add "$email"
}

# Main script execution
echo "This script will add a new email to the Docker Mailserver."

read_user_input
add_email_to_mailserver

echo "Email $email has been added to the Docker Mailserver."
