# 🚀 Quick Start Guide

Für eilige Nutzer - komplette Einrichtung in 30 Minuten!

## Hardware verbinden

1. **Display aufstecken** auf Raspberry Pi GPIO Pins
1. **SD-Karte** mit Raspberry Pi OS einlegen
1. **Stromversorgung** anschließen (Micro-USB “PWR IN”)

## Software installieren

### Via SSH (empfohlen)

```bash
# 1. Mit Pi verbinden
ssh pi@raspberrypi.local

# 2. Repository klonen
git clone https://github.com/DEIN-USERNAME/bitcoin-eink-display.git
cd bitcoin-eink-display

# 3. Automatische Installation
chmod +x setup.sh
bash setup.sh

# 4. Nach Aufforderung: Pi neu starten
sudo reboot
```

### iPhone Hotspot einrichten

```bash
# 1. WLAN konfigurieren
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

# 2. Hinzufügen (ans Ende):
network={
    ssid="iPhone von Max"
    psk="dein-passwort"
    key_mgmt=WPA-PSK
    priority=10
}

# 3. Speichern: Strg+O, Enter, Strg+X

# 4. Neu verbinden
sudo wpa_cli -i wlan0 reconfigure
```

### Service starten

```bash
# Starten
sudo systemctl start bitcoin-display.service

# Status prüfen
sudo systemctl status bitcoin-display.service
```

## ✅ Fertig!

Das Display sollte jetzt den Bitcoin-Kurs anzeigen und alle 5 Minuten aktualisieren.

## 🔍 Troubleshooting

**Display bleibt schwarz?**

```bash
# SPI prüfen
ls /dev/spi*  # Sollte /dev/spidev0.0 zeigen

# Service Logs
sudo journalctl -u bitcoin-display.service -f
```

**Keine Internet-Verbindung?**

```bash
# Verbindung testen
ping -c 4 8.8.8.8

# WLAN Status
iwconfig wlan0
```

**Service startet nicht?**

```bash
# Manuell testen
cd ~/bitcoin-eink-display
python3 bitcoin_display.py
```

## 📚 Detaillierte Anleitungen

- **Hardware:** <HARDWARE.md>
- **Installation:** <INSTALLATION.md>
- **Anpassungen:** <README.md>

## 🆘 Hilfe

- **GitHub Issues:** [Issues öffnen](https://github.com/DEIN-USERNAME/bitcoin-eink-display/issues)
- **Logs:** `sudo journalctl -u bitcoin-display.service -n 50`
