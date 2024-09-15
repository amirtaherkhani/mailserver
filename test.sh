#!/bin/bash

# Function to display usage/help information
display_help() {
    echo "Usage: $0 <mail_domain> <base_domain> <mailserver_ip>"
    echo ""
    echo "This script checks if 'dig' is installed, installs it if needed, and runs DNS queries to check"
    echo "the A, MX, and reverse DNS (PTR) records for your mail server."
    echo ""
    echo "Positional arguments:"
    echo "  mail_domain      The mail server domain (e.g., mail.next-hub.app)"
    echo "  base_domain      The base domain for MX record checks (e.g., next-hub.app)"
    echo "  mailserver_ip    The IP address of the mail server for reverse DNS lookup (e.g., 89.37.6.162)"
    echo ""
    echo "Examples:"
    echo "  $0 mail.next-hub.app next-hub.app 89.37.6.162"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message and exit"
}

# Function to check if dig is installed
check_dig_installed() {
    if ! command -v dig &> /dev/null; then
        echo "dig command is not found. Installing..."
        
        # Check the OS and install dig accordingly
        if [ -f /etc/debian_version ]; then
            echo "Debian-based system detected. Installing dnsutils..."
            sudo apt update
            sudo apt install -y dnsutils
        elif [ -f /etc/redhat-release ]; then
            echo "RedHat-based system detected. Installing bind-utils..."
            sudo yum install -y bind-utils
        else
            echo "Unsupported OS. Please install dig manually."
            exit 1
        fi
    else
        echo "dig is already installed."
    fi
}

# Function to run the DNS tests
run_dns_tests() {
    MAIL_DOMAIN=$1
    BASE_DOMAIN=$2
    MAILSERVER_IP=$3

    echo "Running DNS tests for mail domain: $MAIL_DOMAIN, base domain: $BASE_DOMAIN, and IP: $MAILSERVER_IP..."

    # Run dig for A record
    echo "Testing A record for $MAIL_DOMAIN..."
    dig A $MAIL_DOMAIN

    # Run dig for MX record
    echo "Testing MX record for $BASE_DOMAIN..."
    dig MX $BASE_DOMAIN

    # Run dig for reverse DNS (PTR) record
    echo "Testing reverse DNS (PTR) for IP $MAILSERVER_IP..."
    dig -x $MAILSERVER_IP
}

# Main script execution
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

if [ $# -ne 3 ]; then
    echo "Error: Missing arguments."
    display_help
    exit 1
fi

check_dig_installed
run_dns_tests "$1" "$2" "$3"
