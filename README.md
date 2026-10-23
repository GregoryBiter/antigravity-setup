# Google Antigravity Desktop App — Auto Installer

<p align="center">
  🌐 <b>English</b> &nbsp;|&nbsp; <a href="README.uk.md">🇺🇦 Українська</a>
</p>

---

Automated installer and updater script for the **Google Antigravity Desktop Application** on Linux (x86_64).

### ⚡ Quick Install via `curl`

To download, install, and configure Google Antigravity in a single command:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigraviti-setup/main/install.sh | bash
```

To install a specific version or a custom archive URL:

```bash
curl -sSL https://raw.githubusercontent.com/GregoryBiter/antigraviti-setup/main/install.sh | bash -s -- "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.26.0-6546645232517120/linux-x64/Antigravity.tar.gz"
```

---

### ✨ Features
- **Auto-detection**: Automatically checks `https://antigravity.google/download?os=linux` for the latest x64 release.
- **Fail-safe fallback**: Uses a verified Google Cloud Storage build if the official download page is unreachable or modified.
- **Rootless install**: Unpacks cleanly into `~/.local/bin/antigravity-x64/` (no `sudo` required).
- **Original Icon**: Extracts the official 512×512 PNG icon directly from `resources/app.asar`.
- **Desktop Integration**:
  - Adds a launcher to the application menu (`~/.local/share/applications/antigravity.desktop`).
  - Creates a shortcut on the Desktop with trusted launch permissions.
  - Adds the `antigravity-app` command to `~/.local/bin/` for easy terminal access.
- **Sandbox compatibility**: Configured with `--no-sandbox` for immediate out-of-the-box launching on Linux.

---

### 💻 Local Usage

```bash
git clone https://github.com/GregoryBiter/antigraviti-setup.git
cd antigraviti-setup
chmod +x install.sh
./install.sh
```

---

## License
MIT
