#!/usr/bin/env pwsh
# Optimize vendor folder - removes unnecessary files
# Run this after composer install to reduce upload size

Write-Host "Optimizing vendor folder..." -ForegroundColor Yellow

if (-not (Test-Path vendor)) {
    Write-Host "ERROR: vendor folder not found. Run 'composer install' first." -ForegroundColor Red
    exit 1
}

# Calculate original size
$originalSize = (Get-ChildItem vendor -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB

# Remove .git folders first (biggest space saver!)
Write-Host "  Removing .git folders..." -ForegroundColor White
Get-ChildItem vendor -Recurse -Directory -Filter ".git" -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
}

# Files and folders to remove
$toRemove = @(
    # Documentation and examples
    "*/docs/*",
    "*/doc/*",
    "*/examples/*",
    "*/example/*",
    "*/demo/*",
    "*/demos/*",
    
    # Tests
    "*/tests/*",
    "*/test/*",
    "*/Tests/*",
    "*/Test/*",
    
    # Development files
    "*.md",
    "*.MD",
    "README*",
    "CHANGELOG*",
    "CHANGES*",
    "CONTRIBUTING*",
    "UPGRADE*",
    "AUTHORS*",
    "LICENSE*",
    "LICENCE*",
    ".gitignore",
    ".gitattributes",
    ".editorconfig",
    ".php_cs*",
    ".phpcs.xml*",
    "phpunit.xml*",
    ".travis.yml",
    ".scrutinizer.yml",
    "appveyor.yml",
    "circle.yml",
    ".phan"
)

Write-Host "  Removing unnecessary files..." -ForegroundColor White
foreach ($pattern in $toRemove) {
    Get-ChildItem "vendor\$pattern" -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}

# Calculate final size
$finalSize = (Get-ChildItem vendor -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB
$saved = $originalSize - $finalSize
$percentSaved = [math]::Round(($saved / $originalSize) * 100, 1)

Write-Host "✓ Optimization complete!" -ForegroundColor Green
Write-Host "  Original: $([math]::Round($originalSize, 2)) MB" -ForegroundColor White
Write-Host "  Final: $([math]::Round($finalSize, 2)) MB" -ForegroundColor White
Write-Host "  Saved: $([math]::Round($saved, 2)) MB ($percentSaved%)" -ForegroundColor Cyan
