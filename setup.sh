#!/bin/bash
# Automated setup script for Astro + Tailwind + PHP Form Template
# This script installs all dependencies and configures the project

echo ""
echo "========================================"
echo "  Astro + PHP Form Template Setup"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check Node.js
echo -e "${YELLOW}[1/6] Checking Node.js installation...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}ERROR: Node.js is not installed${NC}"
    echo -e "${RED}Please install Node.js from https://nodejs.org/${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js found: $(node --version)${NC}"
echo ""

# Check PHP
echo -e "${YELLOW}[2/6] Checking PHP installation...${NC}"
if ! command -v php &> /dev/null; then
    echo -e "${RED}ERROR: PHP is not installed${NC}"
    echo -e "${RED}Please install PHP from your package manager${NC}"
    exit 1
fi
echo -e "${GREEN}✓ PHP found: $(php -v | head -n 1)${NC}"
echo ""

# Check Composer
echo -e "${YELLOW}[3/6] Checking Composer installation...${NC}"
if ! command -v composer &> /dev/null; then
    echo -e "${RED}ERROR: Composer is not installed${NC}"
    echo -e "${RED}Please install Composer from https://getcomposer.org/${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Composer found: $(composer --version | head -n 1)${NC}"
echo ""

# Install Node.js dependencies
echo -e "${YELLOW}[4/6] Installing Node.js dependencies...${NC}"
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to install Node.js dependencies${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js dependencies installed${NC}"
echo ""

# Install PHP dependencies
echo -e "${YELLOW}[5/6] Installing PHP dependencies (PHPMailer)...${NC}"
composer install
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to install PHP dependencies${NC}"
    exit 1
fi
echo -e "${GREEN}✓ PHP dependencies installed${NC}"
echo ""

# Create .env file
echo -e "${YELLOW}[6/6] Creating environment configuration...${NC}"
if [ -f ".env" ]; then
    echo -e "${YELLOW}⚠ .env file already exists, skipping...${NC}"
else
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created from .env.example${NC}"
fi
echo ""

# Success message
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✓ Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "1. Edit .env file with your SMTP and Turnstile credentials"
echo "2. Run: npm run dev:all"
echo ""
echo -e "${CYAN}Happy coding! 🚀${NC}"
echo ""
