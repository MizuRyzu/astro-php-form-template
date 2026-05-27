#!/usr/bin/env pwsh
# Prepare deployment script
# This script builds the Astro site and prepares the API backend for deployment

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Preparation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if PHP is installed
Write-Host "[1/5] Checking PHP installation..." -ForegroundColor Yellow
if (-not (Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: PHP is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install PHP from https://windows.php.net/download/" -ForegroundColor Red
    exit 1
}
$phpVersion = php -v | Select-Object -First 1
Write-Host "✓ PHP found: $phpVersion" -ForegroundColor Green
Write-Host ""

# Check if Composer is installed
Write-Host "[2/5] Checking Composer installation..." -ForegroundColor Yellow
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Composer is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Composer from https://getcomposer.org/download/" -ForegroundColor Red
    exit 1
}
$composerVersion = composer --version
Write-Host "✓ Composer found: $composerVersion" -ForegroundColor Green
Write-Host ""

# Install PHP dependencies
Write-Host "[3/5] Installing PHP dependencies..." -ForegroundColor Yellow
try {
    composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist
    if ($LASTEXITCODE -ne 0) {
        throw "Composer install failed"
    }
    Write-Host "✓ PHP dependencies installed successfully" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to install PHP dependencies" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Optimize vendor folder
Write-Host "[3.5/5] Optimizing vendor folder..." -ForegroundColor Yellow
& "$PSScriptRoot\optimize-vendor.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: Vendor optimization failed, continuing anyway..." -ForegroundColor Yellow
}
Write-Host ""

# Build Astro site
Write-Host "[4/5] Building Astro site..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Astro build failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Astro site built successfully" -ForegroundColor Green
Write-Host ""

# Copy API files to dist
Write-Host "[5/5] Copying API files to dist..." -ForegroundColor Yellow
$apiDest = "dist/api"
if (Test-Path $apiDest) {
    Remove-Item $apiDest -Recurse -Force
}
New-Item -ItemType Directory -Path $apiDest -Force | Out-Null

# Copy necessary files
Copy-Item "api/contact.php" -Destination $apiDest
Copy-Item ".htaccess" -Destination "dist/.htaccess" -ErrorAction SilentlyContinue
Copy-Item ".env.example" -Destination "dist/.env.example"
Copy-Item "composer.json" -Destination "dist/composer.json"
Copy-Item "vendor" -Destination "dist/vendor" -Recurse

Write-Host "✓ API files copied to dist" -ForegroundColor Green
Write-Host ""

# Optimize dist/vendor folder
Write-Host "[5.5/5] Optimizing dist/vendor folder..." -ForegroundColor Yellow
Push-Location dist
$originalSize = (Get-ChildItem vendor -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB

# Remove .git folders
Get-ChildItem vendor -Recurse -Directory -Filter ".git" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Remove unnecessary folders
$toRemove = @(
    "vendor\*/docs", "vendor\*/doc", "vendor\*/examples", "vendor\*/example",
    "vendor\*/demo", "vendor\*/demos", "vendor\*/tests", "vendor\*/test",
    "vendor\*/Tests", "vendor\*/Test", "vendor\*/.phan"
)

foreach ($pattern in $toRemove) {
    Get-ChildItem $pattern -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

# Remove documentation files
$docPatterns = @("*.md", "*.MD", "README*", "CHANGELOG*", "LICENSE*", ".gitignore", ".editorconfig")
foreach ($pattern in $docPatterns) {
    Get-ChildItem "vendor\*\$pattern" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

$finalSize = (Get-ChildItem vendor -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB
$saved = $originalSize - $finalSize

Write-Host "✓ Optimization complete! Saved: $([math]::Round($saved, 2)) MB" -ForegroundColor Green
Pop-Location
Write-Host ""

# Final message
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✓ Deployment Package Ready!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your deployment files are in: ./dist/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Don't forget to:" -ForegroundColor Yellow
Write-Host "  1. Upload all files from ./dist/ to your web server" -ForegroundColor White
Write-Host "  2. Create .env file on the server with your SMTP credentials" -ForegroundColor White
Write-Host "  3. Make sure PHP 7.4+ is available on the server" -ForegroundColor White
Write-Host ""
