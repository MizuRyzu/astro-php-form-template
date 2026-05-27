# 🚀 Ako nahrať template na GitHub

## Krok 1: Vytvorte nový repozitár na GitHube

1. Prejdite na https://github.com/new
2. **Repository name**: `astro-php-form-template`
3. **Description**: `Modern Astro + Tailwind + PHP contact form template with PHPMailer`
4. **Public** alebo **Private** (odporúčam Public ak chcete použiť ako template)
5. ✅ Označte **"Template repository"** (to umožní ostatným použiť "Use this template")
6. ❌ NEOZNAČUJTE "Add a README" (už máme)
7. ❌ NEOZNAČUJTE ".gitignore" (už máme)
8. Kliknite **"Create repository"**

---

## Krok 2: Nahrajte súbory na GitHub

V priečinku `astro-php-form-template` spustite:

```powershell
# Inicializujte Git repozitár
git init

# Pridajte všetky súbory
git add .

# Vytvorte prvý commit
git commit -m "Initial commit: Astro + PHP form template"

# Pridajte GitHub remote (NAHRAĎTE 'your-username' za vaše GitHub meno)
git remote add origin https://github.com/your-username/astro-php-form-template.git

# Nahrajte na GitHub
git branch -M main
git push -u origin main
```

---

## Krok 3: Nastavte repozitár ako Template

1. Prejdite na váš repozitár na GitHube
2. Kliknite na **"Settings"** (nastavenia)
3. V sekcii **"Template repository"** označte checkbox
4. Uložte zmeny

---

## Krok 4: Použitie template pre nový projekt

Keď budete chcieť vytvoriť nový projekt:

### ⚡ Cez degit (ODPORÚČANÉ - najrýchlejšie):

```powershell
# Stiahne template bez git histórie
npx degit your-username/astro-php-form-template novy-projekt
cd novy-projekt
.\setup.ps1
```

**Výhody:**

- ✅ Najrýchlejšie
- ✅ Žiadna git história
- ✅ Nie je potrebný GitHub účet pre stiahnutie
- ✅ Funguje okamžite

### Cez GitHub Web:

1. Prejdite na váš template repozitár
2. Kliknite **"Use this template"** → **"Create a new repository"**
3. Zadajte názov nového projektu
4. Kliknite **"Create repository"**
5. Naklonujte nový repozitár:

```powershell
git clone https://github.com/your-username/novy-projekt.git
cd novy-projekt
.\setup.ps1
```

### Cez GitHub CLI:

```powershell
gh repo create novy-projekt --template your-username/astro-php-form-template --public --clone
cd novy-projekt
.\setup.ps1
```

### Klasicky (git clone):

```powershell
git clone https://github.com/your-username/astro-php-form-template.git novy-projekt
cd novy-projekt
rm -rf .git
git init
.\setup.ps1
```

---

## 🎯 Výhody GitHub Template

- ✅ Jednoduchý "Use this template" button na GitHube
- ✅ Každý projekt má vlastnú históriu (clean slate)
- ✅ Žiadne prepojenie s originálnym repozitárom
- ✅ Ideálne pre opakovane používané štruktúry

---

## 📝 Odporúčané úpravy pred nahratím

### 1. Upravte README.md

Zmeňte:

```markdown
git clone https://github.com/your-username/astro-php-form-template.git
```

Na váš skutočný GitHub username.

### 2. Upravte package.json (voliteľné)

Zmeňte author field:

```json
"author": "Your Name",
```

### 3. Doplňte LICENSE

Ak chcete, môžete doplniť svoje meno do LICENSE súboru.

---

## 🔄 Aktualizácia template

Keď budete chcieť aktualizovať template:

```powershell
# Prejdite do template priečinka
cd astro-php-form-template

# Urobte zmeny
# ...

# Commit a push
git add .
git commit -m "Update: popis zmien"
git push
```

**Poznámka**: Zmeny v template sa **neprenesú** automaticky do existujúcich projektov vytvorených z template. Musíte ich aktualizovať manuálne.

---

## 📸 Voliteľné: Pridajte screenshot

Pridajte screenshot do README.md:

1. Vytvorte screenshot stránky
2. Nazvite ho `screenshot.png`
3. Nahrajte do priečinka projektu
4. Pridajte do README.md:

```markdown
## 📸 Preview

![Template Preview](screenshot.png)
```

---

## ⭐ Tip: Pridajte topics na GitHube

Po nahratí na GitHub:

1. Kliknite na ⚙️ vedľa "About" na hlavnej stránke repozitára
2. Pridajte topics: `astro`, `tailwindcss`, `php`, `phpmailer`, `contact-form`, `template`
3. To pomôže ostatným nájsť váš template!

---

**Hotovo! Váš template je teraz na GitHube a pripravený na použitie! 🎉**
