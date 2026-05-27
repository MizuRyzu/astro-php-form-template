#!/usr/bin/env pwsh
# Automated setup script for Astro + Tailwind + PHP Form Template
# This script installs all dependencies and configures the project

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Astro + PHP Form Template Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
Write-Host "[1/6] Checking Node.js installation..." -ForegroundColor Yellow
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Node.js is not installed" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}
$nodeVersion = node --version
Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
Write-Host ""

# Check PHP
Write-Host "[2/6] Checking PHP installation..." -ForegroundColor Yellow
if (-not (Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: PHP is not installed" -ForegroundColor Red
    Write-Host "Please install PHP from https://windows.php.net/download/" -ForegroundColor Red
    exit 1
}
$phpVersion = php -v | Select-Object -First 1
Write-Host "✓ PHP found: $phpVersion" -ForegroundColor Green
Write-Host ""

# Check Composer
Write-Host "[3/6] Checking Composer installation..." -ForegroundColor Yellow
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Composer is not installed" -ForegroundColor Red
    Write-Host "Please install Composer from https://getcomposer.org/download/" -ForegroundColor Red
    exit 1
}
$composerVersion = composer --version | Select-Object -First 1
Write-Host "✓ Composer found: $composerVersion" -ForegroundColor Green
Write-Host ""

# Install Node.js dependencies
Write-Host "[4/6] Installing Node.js dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install Node.js dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Node.js dependencies installed" -ForegroundColor Green
Write-Host ""

# Install PHP dependencies
Write-Host "[5/6] Installing PHP dependencies (PHPMailer)..." -ForegroundColor Yellow
composer install
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install PHP dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✓ PHP dependencies installed" -ForegroundColor Green
Write-Host ""

# Create .env file
Write-Host "[6/6] Creating environment configuration..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host "⚠ .env file already exists, skipping..." -ForegroundColor Yellow
} else {
    Copy-Item ".env.example" ".env"
    Write-Host "✓ .env file created from .env.example" -ForegroundColor Green
}
Write-Host ""

# Success message
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✓ Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Edit .env file with your SMTP and Turnstile credentials" -ForegroundColor White
Write-Host "2. Run: npm run dev:all" -ForegroundColor White
Write-Host ""
Write-Host "Opening .env file for editing..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

# Open .env in default editor
if (Get-Command code -ErrorAction SilentlyContinue) {
    code .env
} else {
    notepad .env
}

Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Cyan
Write-Host ""
