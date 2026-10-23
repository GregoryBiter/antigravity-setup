# Google Antigravity Desktop App — Автоматичний установник

<p align="center">
  <a href="README.md">🌐 English</a> &nbsp;|&nbsp; 🇺🇦 <b>Українська</b>
</p>

---

Скрипт для автоматичного завантаження, встановлення та оновлення десктопного застосунку **Google Antigravity** на Linux (x86_64).

### ⚡ Швидке встановлення через `curl`

Щоб завантажити, встановити та налаштувати Google Antigravity однією командою:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigravity-setup/main/install.sh | bash
```

Встановлення певної версії або за прямим посиланням на архів:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigravity-setup/main/install.sh | bash -s -- "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.26.0-6546645232517120/linux-x64/Antigravity.tar.gz"
```

---

### ✨ Можливості
- **Автопошук оновлень**: Автоматично перевіряє сторінку `https://antigravity.google/download?os=linux` на наявність найсвіжішої версії під x64.
- **Резервне посилання**: Якщо сайт Google недоступний або змінив структуру, автоматично використовується стабільна резервна версія з Google Cloud Storage.
- **Встановлення без root**: Програма розпаковується в папку користувача `~/.local/bin/antigravity-x64/` (права `sudo` не потрібні).
- **Оригінальна іконка**: Автоматично витягує якісну офіційну іконку 512×512 безпосередньо з `resources/app.asar`.
- **Повна інтеграція в систему**:
  - Додає ярлик у системне меню застосунків (`~/.local/share/applications/antigravity.desktop`).
  - Створює ярлик на Робочому столі з необхідними правами запуску.
  - Створює зручну команду `antigravity-app` у `~/.local/bin/` для запуску з термінала.
- **Сумісність із пісочницею**: Сконфігуровано прапорець `--no-sandbox` для запуску без конфліктів із SUID-правами Chrome sandbox.

---

### 💻 Локальне використання

```bash
git clone https://github.com/GregoryBiter/antigravity-setup.git
cd antigravity-setup
chmod +x install.sh
./install.sh
```

---

## Ліцензія
MIT
