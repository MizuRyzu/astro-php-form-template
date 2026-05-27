# 🚀 Astro + PHP Form Template

A modern, production-ready template for building websites with **Astro**, **Tailwind CSS**, and **PHP contact forms** powered by **PHPMailer**.

> **Quick Start:** `npx degit MizuRyzu/astro-php-form-template my-project`  
> 📖 [See full quick start guide](QUICKSTART.md) (Slovak) · [Detailed setup](FORM-SETUP.md)

## ✨ Features

- ⚡ **Astro** - Fast, modern static site generator
- 🎨 **Tailwind CSS** - Utility-first CSS framework
- 📧 **PHPMailer** - Reliable email sending
- 🛡️ **Security Features**:
  - Honeypot spam protection
  - Rate limiting (5 requests/hour per IP)
  - Cloudflare Turnstile support (optional)
  - Input sanitization
- 🔧 **Easy Setup** - Automated installation scripts
- 📦 **Deployment Ready** - Optimized build script

---

## 📋 Prerequisites

Before you begin, make sure you have:

- **Node.js** (v18 or higher)
- **PHP** (v7.4 or higher)
- **Composer** (PHP package manager)

### Windows Installation:

```powershell
# Install via Chocolatey
choco install nodejs php composer

# Or download manually:
# Node.js: https://nodejs.org/
# PHP: https://windows.php.net/download/
# Composer: https://getcomposer.org/download/
```

### Linux/Mac Installation:

```bash
# Ubuntu/Debian
sudo apt install nodejs npm php php-cli composer

# macOS (via Homebrew)
brew install node php composer
```

---

## 🚀 Quick Start

### 1. Create New Project from Template

**Recommended: Using degit (fastest, no git history)**

```powershell
# Windows
npx degit MizuRyzu/astro-php-form-template my-project
cd my-project
```

```bash
# Linux/Mac
npx degit MizuRyzu/astro-php-form-template my-project
cd my-project
```

**Alternative methods:**

<details>
<summary>Using GitHub CLI</summary>

```powershell
gh repo create my-project --template MizuRyzu/astro-php-form-template --public --clone
cd my-project
```

</details>

<details>
<summary>Using git clone</summary>

```bash
git clone https://github.com/MizuRyzu/astro-php-form-template.git my-project
cd my-project
rm -rf .git  # Remove git history
git init     # Start fresh
```

</details>

### 2. Run Setup Script

**Windows:**

```powershell
.\setup.ps1
```

**Linux/Mac:**

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:

- ✅ Check all prerequisites
- ✅ Install Node.js dependencies (Astro, Tailwind, etc.)
- ✅ Install PHP dependencies (PHPMailer)
- ✅ Create `.env` file from template
- ✅ Open `.env` for editing

### 3. Configure Environment Variables

Edit `.env` file with your SMTP credentials:

```env
# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=your-email@gmail.com
SMTP_FROM_NAME=Your Website Name
SMTP_TO=recipient@example.com

# Cloudflare Turnstile (optional)
TURNSTILE_SECRET_KEY=

# Rate Limiting
RATE_LIMIT=5
```

#### 📧 Gmail Setup:

1. Enable 2-Step Verification
2. Go to https://myaccount.google.com/apppasswords
3. Create an App Password for "Mail"
4. Use that password in your `.env` file

### 4. Start Development Server

```bash
npm run dev:all
```

This runs both:

- **Astro dev server** on `http://localhost:4321`
- **PHP server** on `http://localhost:8080`

---

## 📝 Available Scripts

```bash
npm run dev        # Start Astro dev server only
npm run dev:php    # Start PHP server only
npm run dev:all    # Start both servers (recommended)
npm run build      # Build for production
```

**Deployment:**

```powershell
.\prepare-deploy.ps1   # Build and prepare deployment package
```

---

## 🏗️ Project Structure

```
astro-php-form-template/
├── api/
│   └── contact.php           # PHP form handler
├── src/
│   ├── components/
│   │   └── ContactForm.astro # Contact form component
│   ├── layouts/
│   │   └── BaseLayout.astro  # Base layout
│   ├── pages/
│   │   └── index.astro       # Homepage
│   └── styles/
│       └── global.css        # Tailwind styles
├── .env.example              # Environment template
├── .htaccess                 # Apache configuration
├── astro.config.mjs          # Astro configuration
├── composer.json             # PHP dependencies
├── package.json              # Node dependencies
├── prepare-deploy.ps1        # Deployment script
├── optimize-vendor.ps1       # Vendor optimization
└── setup.ps1 / setup.sh      # Setup scripts
```

---

## 🔒 Security Features

### 1. **Honeypot Protection**

Hidden field that bots fill out, legitimate users don't see.

### 2. **Rate Limiting**

Limits submissions to 5 requests per hour per IP address.

### 3. **Input Sanitization**

All user inputs are sanitized before processing.

### 4. **Cloudflare Turnstile** (Optional)

Add CAPTCHA-like bot protection without annoying users.

To enable:

1. Get API keys from https://dash.cloudflare.com/
2. Add `TURNSTILE_SECRET_KEY` to `.env`
3. Update `ContactForm.astro` with your site key
4. Set `hasTurnstile = true` in the component

---

## 🚢 Deployment

### Prepare Deployment Package:

```powershell
.\prepare-deploy.ps1
```

This will:

1. Install production PHP dependencies
2. Build Astro site
3. Copy API files to `dist/`
4. Optimize vendor folder (removes docs, tests, etc.)

### Upload to Server:

1. Upload all files from `dist/` folder
2. Create `.env` file on server with your SMTP credentials
3. Ensure PHP 7.4+ is available
4. Point your domain to the upload directory

### Apache Configuration:

The included `.htaccess` file handles:

- CORS headers
- Protecting sensitive files (`.env`, `composer.json`)
- Rewrite rules for API

---

## 🛠️ Customization

### Change Form Fields:

Edit `src/components/ContactForm.astro` to add/remove fields.

### Style Adjustments:

All styles use Tailwind CSS classes. Modify directly in components or add custom styles to `src/styles/global.css`.

### Email Template:

Customize email HTML in `api/contact.php` (search for `$emailBodyHTML`).

---

## 📚 Documentation

- [Astro Documentation](https://docs.astro.build/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [PHPMailer Documentation](https://github.com/PHPMailer/PHPMailer)

---

## 🐛 Troubleshooting

### Form not sending emails:

1. Check `.env` configuration
2. Verify SMTP credentials
3. Check PHP error logs: `api/contact.php` logs errors
4. Test SMTP connection independently

### PHP server not starting:

```bash
# Check if PHP is in PATH
php --version

# Check if port 8080 is available
# Windows:
netstat -ano | findstr :8080

# Linux/Mac:
lsof -i :8080
```

### Build errors:

```bash
# Clear node_modules and reinstall
rm -rf node_modules
npm install

# Clear Astro cache
rm -rf .astro
npm run build
```

---

## 📄 License

MIT License - feel free to use this template for any project!

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## ⭐ Support

If you find this template helpful, please give it a star on GitHub!

---

**Happy coding! 🚀**
