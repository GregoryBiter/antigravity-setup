# Google Antigravity Desktop App — Auto Installer

Automated installer and updater script for the **Google Antigravity Desktop Application** on Linux (x86_64).

---

## 🇺🇸 English

### Quick Install via `curl`

To download, install, and configure Google Antigravity in one command, run:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigraviti-setup/main/install.sh | bash
```

To install a specific version or direct archive URL:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigraviti-setup/main/install.sh | bash -s -- "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.26.0-6546645232517120/linux-x64/Antigravity.tar.gz"
```

### Features
- **Auto-detection**: Dynamically queries `https://antigravity.google/download?os=linux` for the latest x64 release.
- **Fail-safe fallback**: Automatically falls back to a verified Google Cloud Storage build if the download page is unavailable or changes layout.
- **Clean extraction**: Unpacks into `~/.local/bin/antigravity-x64/` (no root/sudo required).
- **Original Icon**: Automatically extracts the official 512×512 PNG icon from `resources/app.asar`.
- **Desktop Integration**:
  - Adds launcher to the application menu (`~/.local/share/applications/antigravity.desktop`).
  - Adds shortcut to the Desktop with proper permissions.
  - Adds `antigravity-app` command to `~/.local/bin/` for easy terminal access.
- **Sandbox compatibility**: Configured with `--no-sandbox` for smooth out-of-the-box launching without requiring SUID root permissions.

### Local Usage
```bash
git clone https://github.com/GregoryBiter/antigraviti-setup.git
cd antigraviti-setup
chmod +x install.sh
./install.sh
```

---

## 🇺🇦 Українська

### Швидке встановлення через `curl`

Щоб завантажити, встановити та налаштувати Google Antigravity однією командою, виконайте:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigraviti-setup/main/install.sh | bash
```

Встановлення певної версії або за прямим посиланням на архів:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigraviti-setup/main/install.sh | bash -s -- "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.26.0-6546645232517120/linux-x64/Antigravity.tar.gz"
```

### Можливості
- **Автопошук оновлень**: Автоматично знаходить посилання на найсвіжішу x64-версію на офіційній сторінці `https://antigravity.google/download?os=linux`.
- **Резервне посилання**: Якщо сайт Google недоступний або змінив структуру, автоматично використовується перевірене резервне посилання з Google Cloud Storage.
- **Безпечне встановлення**: Розпаковує програму в `~/.local/bin/antigravity-x64/` (права `root` / `sudo` не потрібні).
- **Оригінальна іконка**: Автоматично витягує якісну офіційну іконку 512×512 безпосередньо з `resources/app.asar`.
- **Інтеграція в систему**:
  - Додає ярлик у системне меню програм (`~/.local/share/applications/antigravity.desktop`).
  - Створює ярлик на Робочому столі з необхідними правами довіри (`trusted`).
  - Створює зручну команду `antigravity-app` у `~/.local/bin/` для швидкого запуску через термінал.
- **Сумісність із пісочницею**: Налаштовано прапорець `--no-sandbox` для запуску без конфліктів із SUID-правами Chrome sandbox.

### Локальне використання
```bash
git clone https://github.com/GregoryBiter/antigraviti-setup.git
cd antigraviti-setup
chmod +x install.sh
./install.sh
```

---

## License
MIT
