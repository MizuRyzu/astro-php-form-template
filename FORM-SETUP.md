# 📧 Contact Form Setup Guide

This guide provides detailed information about the PHP contact form implementation with PHPMailer.

---

## 🎯 Features

- ✅ **PHPMailer** - Reliable email sending via SMTP
- ✅ **Cloudflare Turnstile** - Bot protection (optional)
- ✅ **Honeypot Protection** - Hidden spam trap
- ✅ **Rate Limiting** - Max 5 requests per hour per IP
- ✅ **Input Sanitization** - XSS protection
- ✅ **AJAX Submission** - No page reload
- ✅ **Responsive Design** - Mobile-friendly

---

## 📋 Prerequisites

1. **Node.js** (v18+)
2. **PHP** (v7.4+)
3. **Composer**
4. **SMTP Server** (Gmail, SendGrid, etc.)

---

## 🚀 Setup Instructions

### Step 1: Install Dependencies

Run the setup script:

**Windows:**

```powershell
.\setup.ps1
```

**Linux/Mac:**

```bash
./setup.sh
```

### Step 2: Configure SMTP

Edit `.env` file:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=your-email@gmail.com
SMTP_FROM_NAME=Your Website Name
SMTP_TO=recipient@example.com
```

#### Gmail Configuration:

1. Enable 2-Step Verification at https://myaccount.google.com/security
2. Create App Password at https://myaccount.google.com/apppasswords
3. Use the generated password in `.env`

#### Other SMTP Providers:

**SendGrid:**

```env
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=your-sendgrid-api-key
```

**Mailgun:**

```env
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USERNAME=postmaster@your-domain.mailgun.org
SMTP_PASSWORD=your-mailgun-password
```

### Step 3: Configure Cloudflare Turnstile (Optional)

1. Go to https://dash.cloudflare.com/
2. Navigate to **Turnstile** section
3. Create a new site
4. Copy **Site Key** and **Secret Key**

Add to `.env`:

```env
TURNSTILE_SECRET_KEY=your-secret-key
```

Update `src/components/ContactForm.astro`:

```javascript
// Line ~72
const hasTurnstile = true; // Enable Turnstile

// Line ~54 - Replace with your site key
<div class="cf-turnstile" data-sitekey="YOUR_SITE_KEY"></div>;
```

---

## 🔧 Customization

### Change Form Fields

Edit `src/components/ContactForm.astro`:

```html
<!-- Add new field -->
<div>
  <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">
    Phone
  </label>
  <input
    type="tel"
    id="phone"
    name="phone"
    class="w-full px-4 py-2 border border-gray-300 rounded-lg"
    placeholder="+421 900 000 000"
  />
</div>
```

Update `api/contact.php` to process new field:

```php
// Get new field
$phone = sanitizeInput($data['phone'] ?? '');

// Add to email template
<div class='field'>
    <div class='label'>Phone:</div>
    <div class='value'>{$phone}</div>
</div>
```

### Customize Email Template

Edit `api/contact.php` (around line 180):

```php
$emailBodyHTML = "
    <html>
    <head>
        <style>
            /* Customize styles here */
            .header { background-color: #4F46E5; }
        </style>
    </head>
    <body>
        <!-- Customize email content here -->
    </body>
    </html>
";
```

### Change Rate Limit

Edit `.env`:

```env
# Allow 10 requests per hour instead of 5
RATE_LIMIT=10
```

---

## 🔒 Security Features Explained

### 1. Honeypot Protection

Hidden field that bots fill out:

```html
<input
  type="text"
  name="website"
  class="hidden"
  tabindex="-1"
  autocomplete="off"
/>
```

If this field has a value, the submission is rejected.

### 2. Rate Limiting

File: `api/contact.php` (line 52)

Tracks IP addresses and timestamps in `api/rate-limit.json`:

```json
{
  "192.168.1.1": [1622547600, 1622548200],
  "192.168.1.2": [1622548800]
}
```

Old entries are automatically cleaned up.

### 3. Input Sanitization

```php
function sanitizeInput($data) {
  return htmlspecialchars(strip_tags(trim($data)));
}
```

Removes HTML tags and special characters to prevent XSS attacks.

### 4. CORS Headers

```php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
```

Allows requests from your Astro dev server.

---

## 🧪 Testing

### Development Testing:

1. Start both servers:

```bash
npm run dev:all
```

2. Open http://localhost:4321
3. Fill out the form
4. Check your email

### Production Testing:

After deployment, test:

- ✅ Form submission works
- ✅ Emails are received
- ✅ Rate limiting works (try 6 submissions quickly)
- ✅ Honeypot works (manually fill hidden field)
- ✅ Validation works (try invalid email)

---

## 🐛 Troubleshooting

### Email not sending:

**Check PHP error logs:**

Add to `api/contact.php` (at the end of catch block):

```php
catch (Exception $e) {
  // Enable error logging
  error_log("Mailer Error: " . $e->getMessage());
  error_log("Stack trace: " . $e->getTraceAsString());
}
```

**Test SMTP connection:**

Create `test-smtp.php` in `api/` folder:

```php
<?php
require_once __DIR__ . '/../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;

// Load .env
$envFile = __DIR__ . '/../.env';
$lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach ($lines as $line) {
    if (strpos(trim($line), '#') === 0) continue;
    list($key, $value) = explode('=', $line, 2);
    $_ENV[trim($key)] = trim($value);
}

$mail = new PHPMailer(true);
$mail->isSMTP();
$mail->Host = $_ENV['SMTP_HOST'];
$mail->SMTPAuth = true;
$mail->Username = $_ENV['SMTP_USERNAME'];
$mail->Password = $_ENV['SMTP_PASSWORD'];
$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = $_ENV['SMTP_PORT'];
$mail->SMTPDebug = 2; // Enable verbose debug output

try {
    $mail->setFrom($_ENV['SMTP_FROM']);
    $mail->addAddress($_ENV['SMTP_TO']);
    $mail->Subject = 'SMTP Test';
    $mail->Body = 'Test email from PHPMailer';
    $mail->send();
    echo "Email sent successfully!";
} catch (Exception $e) {
    echo "Error: " . $mail->ErrorInfo;
}
```

Run: http://localhost:8080/test-smtp.php

### CORS errors:

If you see CORS errors in browser console:

1. Check `.htaccess` is present
2. Verify Apache has `mod_headers` enabled
3. For production, update `Access-Control-Allow-Origin` header in `api/contact.php`

### Rate limit not working:

Check file permissions:

```bash
# Linux/Mac
chmod 777 api/

# Windows - make sure IIS/Apache can write to api/ folder
```

---

## 📚 API Reference

### Endpoint: `POST /api/contact.php`

**Request Body:**

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "message": "Hello!",
  "website": "",
  "cf-turnstile-response": "token..."
}
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Thank you for your message. We will get back to you soon."
}
```

**Error Responses:**

```json
// 400 - Validation error
{
  "success": false,
  "message": "Please fill in all required fields."
}

// 429 - Rate limit exceeded
{
  "success": false,
  "message": "Too many requests. Please try again later."
}

// 500 - Server error
{
  "success": false,
  "message": "An error occurred while sending the message."
}
```

---

## 🚀 Performance Optimization

### Vendor Folder Optimization

The `optimize-vendor.ps1` script removes:

- Documentation files (\*.md, README, etc.)
- Test files
- Example files
- .git folders

This reduces upload size by ~60-70%!

Before optimization: ~15 MB  
After optimization: ~5 MB

---

## 📝 Environment Variables Reference

| Variable               | Required | Default      | Description                  |
| ---------------------- | -------- | ------------ | ---------------------------- |
| `SMTP_HOST`            | Yes      | -            | SMTP server hostname         |
| `SMTP_PORT`            | Yes      | 587          | SMTP port (587 or 465)       |
| `SMTP_USERNAME`        | Yes      | -            | SMTP username/email          |
| `SMTP_PASSWORD`        | Yes      | -            | SMTP password                |
| `SMTP_FROM`            | Yes      | -            | From email address           |
| `SMTP_FROM_NAME`       | No       | Contact Form | From name                    |
| `SMTP_TO`              | Yes      | -            | Recipient email address      |
| `TURNSTILE_SECRET_KEY` | No       | -            | Cloudflare Turnstile secret  |
| `RATE_LIMIT`           | No       | 5            | Max requests per hour per IP |

---

## 🔗 Useful Links

- [PHPMailer GitHub](https://github.com/PHPMailer/PHPMailer)
- [PHPMailer Troubleshooting](https://github.com/PHPMailer/PHPMailer/wiki/Troubleshooting)
- [Cloudflare Turnstile Docs](https://developers.cloudflare.com/turnstile/)
- [Gmail App Passwords](https://support.google.com/accounts/answer/185833)

---

**Need help? Check the main README.md or open an issue on GitHub!**
