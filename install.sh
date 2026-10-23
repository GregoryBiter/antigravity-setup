#!/usr/bin/env bash
#
# Auto-installer for Google Antigravity Desktop App (Linux x64)
# Searches for the latest version on the official Google download page,
# falls back to a verified release if unreachable, extracts to ~/.local/bin/antigravity-x64,
# extracts original high-resolution icon from app.asar, and configures desktop integration.
#

set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin/antigravity-x64}"
APPLICATIONS_DIR="$HOME/.local/share/applications"
DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"

GOOGLE_DOWNLOAD_PAGE="https://antigravity.google/download?os=linux"
FALLBACK_URL="https://storage.googleapis.com/antigravity-public/antigravity-hub/2.26.0-6546645232517120/linux-x64/Antigravity.tar.gz"

echo "=========================================================="
echo "    Google Antigravity Desktop App — Auto Installer       "
echo "=========================================================="

# Check required utilities
for cmd in curl tar; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[-] Error: required command '$cmd' is not installed." >&2
        exit 1
    fi
done

# Check currently installed version
CURRENT_VER="not installed"
if [ -f "$INSTALL_DIR/.installed_version" ]; then
    CURRENT_VER="$(cat "$INSTALL_DIR/.installed_version")"
fi
echo "[i] Current local version: $CURRENT_VER"

# Determine download URL
DOWNLOAD_URL=""
DETECTED_VER=""

if [ -n "${1:-}" ]; then
    DOWNLOAD_URL="$1"
    echo "[+] Using direct URL provided in arguments:"
    echo "    $DOWNLOAD_URL"
else
    echo "[*] Checking for latest version on Google download page..."
    
    PAGE_HTML="$(curl -sL --compressed -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" "$GOOGLE_DOWNLOAD_PAGE" 2>/dev/null || true)"
    
    SCRAPED_URL="$(echo "$PAGE_HTML" | grep -o 'https://storage.googleapis.com/antigravity-public/antigravity-hub/[^"'\''<> ]*linux-x64/Antigravity.tar.gz' | head -n 1 || true)"
    
    if [ -z "$SCRAPED_URL" ]; then
        SCRAPED_URL="$(echo "$PAGE_HTML" | grep -o 'https://[^"'\''<> ]*linux-x64/Antigravity.tar.gz' | head -n 1 || true)"
    fi

    if [ -n "$SCRAPED_URL" ]; then
        DOWNLOAD_URL="$SCRAPED_URL"
        DETECTED_VER="$(echo "$DOWNLOAD_URL" | sed -n 's#.*/antigravity-hub/\([^/]*\)/linux-x64/.*#\1#p')"
        echo "[✓] Found latest release: ${DETECTED_VER:-unknown revision}"
        echo "    $DOWNLOAD_URL"
    else
        echo "[!] Could not fetch URL dynamically from download page."
        echo "[*] Falling back to default verified release:"
        DOWNLOAD_URL="$FALLBACK_URL"
        DETECTED_VER="$(echo "$DOWNLOAD_URL" | sed -n 's#.*/antigravity-hub/\([^/]*\)/linux-x64/.*#\1#p')"
        echo "    $DOWNLOAD_URL"
    fi
fi

# Setup temporary directory with cleanup trap
TMP_DIR="$(mktemp -d /tmp/antigravity-setup.XXXXXX)"
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARCHIVE_PATH="$TMP_DIR/Antigravity.tar.gz"

# Download archive
echo "[*] Downloading archive..."
curl -# -L -o "$ARCHIVE_PATH" "$DOWNLOAD_URL"

if [ ! -s "$ARCHIVE_PATH" ]; then
    echo "[-] Error: downloaded archive is empty or missing." >&2
    exit 1
fi

# Prepare target directory
echo "[*] Preparing target directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Extract archive
echo "[*] Extracting files..."
tar -xzf "$ARCHIVE_PATH" -C "$INSTALL_DIR" --strip-components=1

# Record installed version
if [ -n "$DETECTED_VER" ]; then
    echo "$DETECTED_VER" > "$INSTALL_DIR/.installed_version"
fi

# Set executable permissions
chmod +x "$INSTALL_DIR/antigravity" "$INSTALL_DIR/chrome-sandbox" 2>/dev/null || true

# Extract high-resolution icon from app.asar
ICON_PATH="$INSTALL_DIR/antigravity.png"
ASAR_PATH="$INSTALL_DIR/resources/app.asar"

if command -v python3 >/dev/null 2>&1 && [ -f "$ASAR_PATH" ]; then
    echo "[*] Extracting application icon..."
    python3 -c "
import struct, json, os

asar = '$ASAR_PATH'
icon_out = '$ICON_PATH'
try:
    with open(asar, 'rb') as f:
        raw = f.read(16)
        size1 = struct.unpack('<I', raw[4:8])[0]
        size3 = struct.unpack('<I', raw[12:16])[0]
        header = json.loads(f.read(size3).decode('utf-8'))
        icon_info = header['files'].get('icon.png')
        if icon_info:
            offset = 8 + size1 + int(icon_info['offset'])
            f.seek(offset)
            with open(icon_out, 'wb') as out_f:
                out_f.write(f.read(int(icon_info['size'])))
            print('    [✓] Saved icon to: ' + icon_out)
except Exception as e:
    print('    [!] Icon extraction note:', e)
"
fi

# Create .desktop file for system applications menu
mkdir -p "$APPLICATIONS_DIR"
DESKTOP_FILE="$APPLICATIONS_DIR/antigravity.desktop"

echo "[*] Creating application launcher: $DESKTOP_FILE"
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Antigravity
Comment=Google Antigravity Desktop Application
Exec="$INSTALL_DIR/antigravity" --no-sandbox %U
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Utility;Development;
StartupNotify=true
StartupWMClass=Antigravity
MimeType=x-scheme-handler/antigravity;
EOF

chmod +x "$DESKTOP_FILE"

# Place desktop shortcut if desktop folder exists
if [ -d "$DESKTOP_DIR" ]; then
    echo "[*] Creating Desktop shortcut..."
    cp "$DESKTOP_FILE" "$DESKTOP_DIR/antigravity.desktop"
    chmod +x "$DESKTOP_DIR/antigravity.desktop"
    gio set "$DESKTOP_DIR/antigravity.desktop" metadata::trusted true 2>/dev/null || true
fi

# Update desktop application database
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APPLICATIONS_DIR" 2>/dev/null || true
fi

# CLI wrapper in ~/.local/bin/antigravity-app
mkdir -p "$HOME/.local/bin"
WRAPPER="$HOME/.local/bin/antigravity-app"
cat <<EOF > "$WRAPPER"
#!/usr/bin/env bash
exec "$INSTALL_DIR/antigravity" --no-sandbox "\$@"
EOF
chmod +x "$WRAPPER"

echo "=========================================================="
echo "[✓] Google Antigravity Desktop App successfully installed!"
echo "    - Version: ${DETECTED_VER:-2.26.0}"
echo "    - Directory: $INSTALL_DIR"
echo "    - Applications menu: $DESKTOP_FILE"
if [ -d "$DESKTOP_DIR" ]; then
    echo "    - Desktop shortcut: $DESKTOP_DIR/antigravity.desktop"
fi
echo "    - Terminal command: antigravity-app"
echo "=========================================================="
