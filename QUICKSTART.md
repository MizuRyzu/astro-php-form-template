# ⚡ Rýchly Štart

## Vytvorenie nového projektu (1 minúta)

### Krok 1: Stiahnutie template

```powershell
npx degit your-username/astro-php-form-template moj-projekt
cd moj-projekt
```

**Poznámka:** Nahraďte `your-username` za vaše GitHub meno a `moj-projekt` za názov vášho projektu.

### Krok 2: Automatická inštalácia

```powershell
.\setup.ps1
```

Toto nainštaluje:

- ✅ Node.js dependencies (Astro, Tailwind, Concurrently)
- ✅ PHP dependencies (PHPMailer)
- ✅ Vytvorí .env súbor

### Krok 3: Konfigurácia .env

Otvorí sa automaticky `.env` súbor. Vyplňte:

```env
SMTP_HOST=smtp.gmail.com
SMTP_USERNAME=vas-email@gmail.com
SMTP_PASSWORD=vase-app-password
SMTP_TO=prijemca@example.com
```

**Gmail App Password:**

1. https://myaccount.google.com/security
2. 2-Step Verification → App passwords
3. Vytvoriť → Mail
4. Skopírovať heslo

### Krok 4: Spustenie dev servera

```powershell
npm run dev:all
```

Otvára:

- 🌐 **Astro**: http://localhost:4321
- 📧 **PHP API**: http://localhost:8080

---

## Príkazy

| Príkaz                 | Popis                     |
| ---------------------- | ------------------------- |
| `npm run dev:all`      | Spustí Astro + PHP server |
| `npm run dev`          | Len Astro server          |
| `npm run build`        | Build pre produkciu       |
| `.\prepare-deploy.ps1` | Pripraviť deployment      |

---

## 📁 Dôležité súbory

- `.env` - SMTP konfigurácia (NEVERZOVAŤ!)
- `src/components/ContactForm.astro` - Kontaktný formulár
- `api/contact.php` - PHP backend
- `src/pages/index.astro` - Homepage

---

## 🚀 Deployment

```powershell
.\prepare-deploy.ps1
```

Nahrajte `dist/` priečinok na server a vytvorte tam `.env` súbor.

---

## 🆘 Časté problémy

**Formulár neodosiela email:**

- Skontrolujte `.env` konfiguráciu
- Pre Gmail použite App Password, nie normálne heslo
- Skontrolujte `SMTP_HOST` a `SMTP_PORT`

**PHP server sa nespúšťa:**

```powershell
php --version  # Skontrolujte či je PHP nainštalované
```

**Node.js chyby:**

```powershell
rm -rf node_modules
npm install
```

---

**Viac info:** Pozrite [README.md](README.md) alebo [FORM-SETUP.md](FORM-SETUP.md)
