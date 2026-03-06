#!/bin/bash

# Bitcoin Display Setup Script für Raspberry Pi Zero 2 W

# mit Waveshare 2.13” E-Paper HAT V4

# Automatisierte Installation aller Komponenten

set -e  # Bei Fehler abbrechen

# Farben für Output

RED=’\033[0;31m’
GREEN=’\033[0;32m’
YELLOW=’\033[1;33m’
NC=’\033[0m’ # No Color

echo “================================================”
echo “Bitcoin Display Setup”
echo “Raspberry Pi Zero 2 W + Waveshare E-Paper V4”
echo “================================================”
echo “”

# Prüfe ob als root ausgeführt

if [ “$EUID” -eq 0 ]; then
echo -e “${RED}Bitte NICHT als root ausführen!${NC}”
echo “Führe aus mit: bash setup.sh”
exit 1
fi

# Prüfe Raspberry Pi Modell

if ! grep -q “Raspberry Pi Zero 2” /proc/cpuinfo; then
echo -e “${YELLOW}Warnung: Kein Raspberry Pi Zero 2 W erkannt${NC}”
echo “Dieses Script ist für Pi Zero 2 W optimiert.”
read -p “Trotzdem fortfahren? (j/n) “ -n 1 -r
echo
if [[ ! $REPLY =~ ^[Jj]$ ]]; then
exit 1
fi
fi

# System Update

echo -e “${GREEN}1. System wird aktualisiert…${NC}”
sudo apt-get update
sudo apt-get upgrade -y

# Pakete installieren

echo “”
echo -e “${GREEN}2. Installiere benötigte Pakete…${NC}”
sudo apt-get install -y   
python3-pip   
python3-pil   
python3-numpy   
git   
fonts-dejavu   
fonts-dejavu-core   
python3-dev   
libjpeg-dev   
zlib1g-dev

# Python-Bibliotheken

echo “”
echo -e “${GREEN}3. Installiere Python-Bibliotheken…${NC}”
echo “→ requests”
sudo pip3 install requests –break-system-packages

echo “→ Pillow”
sudo pip3 install Pillow –break-system-packages

echo “→ waveshare-epd”
sudo pip3 install waveshare-epd –break-system-packages || {
echo -e “${YELLOW}Waveshare EPD Installation fehlgeschlagen${NC}”
echo “Versuche manuelle Installation…”
cd /tmp
git clone https://github.com/waveshare/e-Paper.git
cd e-Paper/RaspberryPi_JetsonNano/python
sudo python3 setup.py install
cd ~
echo -e “${GREEN}Manuelle Installation abgeschlossen${NC}”
}

# SPI aktivieren

echo “”
echo -e “${GREEN}4. Prüfe SPI-Interface…${NC}”
if ! grep -q “^dtparam=spi=on” /boot/config.txt; then
echo “Aktiviere SPI…”
echo “dtparam=spi=on” | sudo tee -a /boot/config.txt
echo -e “${YELLOW}WARNUNG: Reboot erforderlich nach diesem Script!${NC}”
REBOOT_NEEDED=1
else
echo “SPI ist bereits aktiviert ✓”
fi

# GPIO Gruppe

echo “”
echo -e “${GREEN}5. Konfiguriere Benutzerrechte…${NC}”
sudo usermod -a -G spi,gpio $USER

# Projektverzeichnis erstellen

echo “”
echo -e “${GREEN}6. Erstelle Projektverzeichnis…${NC}”
INSTALL_DIR=”$HOME/bitcoin-eink-display”
mkdir -p “$INSTALL_DIR”

# Prüfe ob bitcoin_display.py existiert

if [ ! -f “bitcoin_display.py” ]; then
echo -e “${RED}FEHLER: bitcoin_display.py nicht gefunden!${NC}”
echo “Bitte stelle sicher, dass bitcoin_display.py im aktuellen Verzeichnis ist.”
exit 1
fi

# Kopiere Dateien

echo “Kopiere Programm nach $INSTALL_DIR”
cp bitcoin_display.py “$INSTALL_DIR/”
chmod +x “$INSTALL_DIR/bitcoin_display.py”

# Kopiere Config-Beispiel falls vorhanden

if [ -f “config.example.py” ]; then
cp config.example.py “$INSTALL_DIR/”
echo “Config-Beispiel kopiert ✓”
fi

# Erstelle Systemd Service

echo “”
echo -e “${GREEN}7. Erstelle Systemd Service für Autostart…${NC}”
sudo tee /etc/systemd/system/bitcoin-display.service > /dev/null <<EOF
[Unit]
Description=Bitcoin E-Ink Display (Waveshare V4)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/python3 $INSTALL_DIR/bitcoin_display.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Service aktivieren

sudo systemctl daemon-reload
sudo systemctl enable bitcoin-display.service
echo “Service aktiviert ✓”

# Test-Script erstellen

echo “”
echo -e “${GREEN}8. Erstelle Test-Script…${NC}”
cat > “$INSTALL_DIR/test.sh” <<‘EOF’
#!/bin/bash
echo “=== Bitcoin Display Test ===”
echo “”
echo “1. SPI Check:”
ls /dev/spi* 2>/dev/null && echo “✓ SPI verfügbar” || echo “✗ SPI nicht gefunden”
echo “”
echo “2. Python Dependencies:”
python3 -c “import requests; print(‘✓ requests’)” 2>/dev/null || echo “✗ requests fehlt”
python3 -c “import PIL; print(‘✓ Pillow’)” 2>/dev/null || echo “✗ Pillow fehlt”
python3 -c “import waveshare_epd; print(‘✓ waveshare-epd’)” 2>/dev/null || echo “✗ waveshare-epd fehlt”
echo “”
echo “3. Internet Check:”
ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo “✓ Internet verfügbar” || echo “✗ Keine Internetverbindung”
echo “”
echo “4. Service Status:”
systemctl is-active –quiet bitcoin-display.service && echo “✓ Service läuft” || echo “○ Service gestoppt”
EOF
chmod +x “$INSTALL_DIR/test.sh”

echo “”
echo “================================================”
echo -e “${GREEN}Installation abgeschlossen!${NC}”
echo “================================================”
echo “”
echo “📋 Nächste Schritte:”
echo “”
echo “1️⃣  iPhone Hotspot konfigurieren:”
echo “   ${YELLOW}sudo nano /etc/wpa_supplicant/wpa_supplicant.conf${NC}”
echo “”
echo “   Füge hinzu:”
echo “   network={”
echo ’     ssid=“iPhone von [Name]”’
echo ’     psk=“DeinPasswort”’
echo “     key_mgmt=WPA-PSK”
echo “     priority=10”
echo “   }”
echo “”
echo “2️⃣  WLAN neu starten:”
echo “   ${YELLOW}sudo wpa_cli -i wlan0 reconfigure${NC}”
echo “”
echo “3️⃣  Display anschließen (Falls noch nicht)”
echo “   - Pi ausschalten: ${YELLOW}sudo shutdown -h now${NC}”
echo “   - E-Paper HAT aufstecken”
echo “   - Pi wieder einschalten”
echo “”
echo “4️⃣  Service starten:”
echo “   ${YELLOW}sudo systemctl start bitcoin-display.service${NC}”
echo “”
echo “5️⃣  Status prüfen:”
echo “   ${YELLOW}sudo systemctl status bitcoin-display.service${NC}”
echo “   ${YELLOW}$INSTALL_DIR/test.sh${NC}”
echo “”
echo “6️⃣  Logs ansehen:”
echo “   ${YELLOW}sudo journalctl -u bitcoin-display.service -f${NC}”
echo “”

if [ -n “$REBOOT_NEEDED” ]; then
echo -e “${RED}⚠️  WICHTIG: Reboot erforderlich!${NC}”
echo “   Für SPI-Aktivierung: ${YELLOW}sudo reboot${NC}”
echo “”
fi

echo “📁 Installation in: ${YELLOW}$INSTALL_DIR${NC}”
echo “📖 Dokumentation: https://github.com/DEIN-USERNAME/bitcoin-eink-display”
echo “”
echo “================================================”
echo -e “${GREEN}Viel Erfolg! 🚀${NC}”
echo “================================================”
