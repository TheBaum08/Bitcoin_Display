# 🪙 Bitcoin E-Ink Display

<div align="center">

![GitHub release](https://img.shields.io/github/v/release/yourusername/bitcoin-eink-display?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/yourusername/bitcoin-eink-display?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues/yourusername/bitcoin-eink-display?style=flat-square)
![License](https://img.shields.io/github/license/yourusername/bitcoin-eink-display?style=flat-square)
![Python](https://img.shields.io/badge/python-3.7+-blue?style=flat-square&logo=python)

**Live cryptocurrency price tracking on E-Ink displays**  
*Energy-efficient • Multi-platform • Open source*

[Features](#-features) • [Quick Start](#-quick-start) • [Hardware](#-supported-hardware) • [Documentation](#-documentation) • [Contributing](#-contributing)

![Bitcoin Display Demo](https://via.placeholder.com/600x200/000000/FFFFFF?text=Bitcoin+Display+Demo)

</div>

-----

## 📸 What It Shows

<table>
<tr>
<td width="50%">

**Display Output:**

- 💶 Bitcoin price in EUR
- 💵 Bitcoin price in USD
- 📊 24h price change (▲/▼)
- 🕐 Last update timestamp
- 🔋 Battery-friendly updates

</td>
<td width="50%">

**Live Example:**

```
┌─────────────────────┐
│ BITCOIN (BTC)       │
│─────────────────────│
│ € 88,234            │
│ $ 95,123       ▲2.3%│
│─────────────────────│
│ 06.03.2026 14:30    │
└─────────────────────┘
```

</td>
</tr>
</table>

## ✨ Features

<table>
<tr>
<td width="50%">

### Core Features

- 🔄 **Auto-updates** every 5 minutes
- 💱 **Dual currency** EUR & USD display
- 📈 **Trend indicators** with up/down arrows
- ⚡ **Energy efficient** E-Ink technology
- 🔌 **Auto-start** on system boot
- 📡 **WiFi ready** iPhone Hotspot support

</td>
<td width="50%">

### Developer Features

- 🛠️ **Multi-platform** 6 boards supported
- 🖥️ **Multi-display** 6 E-Ink displays
- 🎯 **Auto-detection** hardware recognition
- 🧪 **Test suite** complete diagnostics
- 📚 **5000+ lines** comprehensive docs
- 🆓 **Free API** no API keys needed

</td>
</tr>
</table>

## 🔧 Supported Hardware

### 🎯 Recommended Setup

|Component  |Model                |Price   |Why?                              |
|-----------|---------------------|--------|----------------------------------|
|**Board**  |Raspberry Pi Zero 2 W|~22€    |Best price/performance ratio      |
|**Display**|Waveshare 2.13” V4   |~20€    |Partial refresh, modern controller|
|**Power**  |USB 5V/2A adapter    |~10€    |Reliable power supply             |
|**Storage**|microSD 8GB+ Class 10|~8€     |Fast, reliable                    |
|**Total**  |**Complete setup**   |**~60€**|Ready to go!                      |

### 🖥️ All Supported Platforms

<details>
<summary><b>Click to expand full compatibility matrix</b></summary>

|Platform                 |CPU             |RAM  |Power |Update Interval|Status           |
|-------------------------|----------------|-----|------|---------------|-----------------|
|Raspberry Pi Zero W      |ARM11 1GHz      |512MB|~0.4W |10 min         |✅ Supported      |
|**Raspberry Pi Zero 2 W**|ARM A53 4×1GHz  |512MB|~0.75W|5 min          |⭐ **Recommended**|
|Raspberry Pi 3 B/B+      |ARM A53 4×1.4GHz|1GB  |~2-3W |3 min          |✅ Supported      |
|Raspberry Pi 4 B         |ARM A72 4×1.8GHz|2-8GB|~3-4W |2 min          |✅ Supported      |
|Raspberry Pi 5           |ARM A76 4×2.4GHz|4-8GB|~5W   |1 min          |✅ Supported      |
|ESP32 (LILYGO T5)        |Xtensa 2×240MHz |520KB|~0.3W*|15 min         |✅ Supported      |

*ESP32 with deep sleep: <0.01W, weeks of battery life

</details>

### 📺 All Supported Displays

<details>
<summary><b>Click to expand display options</b></summary>

|Display               |Resolution|Size |Partial Refresh|Price|Platform      |
|----------------------|----------|-----|---------------|-----|--------------|
|Waveshare 2.13” V3    |250×122   |2.13”|❌              |~15€ |Raspberry Pi  |
|**Waveshare 2.13” V4**|250×122   |2.13”|✅              |~20€ |Raspberry Pi ⭐|
|Waveshare 2.9” V2     |296×128   |2.9” |✅              |~18€ |Raspberry Pi  |
|Waveshare 4.2”        |400×300   |4.2” |❌              |~25€ |Raspberry Pi  |
|Waveshare 7.5” V2     |800×480   |7.5” |✅              |~50€ |Raspberry Pi  |
|LILYGO T5             |200×200   |2.13”|✅              |~25€*|ESP32 only    |

*Includes integrated ESP32

</details>


> 💡 **Not sure which to choose?** Run our interactive setup wizard:
> 
> ```bash
> python3 hardware_setup.py
> ```

## 🔌 Verkabelung

Das Waveshare HAT wird direkt auf die GPIO-Pins gesteckt:

|E-Ink HAT Pin|Raspberry Pi Pin|BCM GPIO      |Funktion       |
|-------------|----------------|--------------|---------------|
|VCC          |Pin 1           |3.3V          |Stromversorgung|
|GND          |Pin 6           |GND           |Masse          |
|DIN          |Pin 19          |GPIO 10 (MOSI)|SPI Daten      |
|CLK          |Pin 23          |GPIO 11 (SCLK)|SPI Clock      |
|CS           |Pin 24          |GPIO 8 (CE0)  |Chip Select    |
|DC           |Pin 22          |GPIO 25       |Data/Command   |
|RST          |Pin 11          |GPIO 17       |Reset          |
|BUSY         |Pin 18          |GPIO 24       |Busy Flag      |


> **Hinweis:** Bei der HAT-Version einfach aufstecken - keine manuelle Verkabelung nötig!

## 🚀 Quick Start

### One-Command Installation (Raspberry Pi)

```bash
# Clone repository
git clone https://github.com/yourusername/bitcoin-eink-display.git
cd bitcoin-eink-display

# Run automated setup
chmod +x setup.sh
./setup.sh

# Configure WiFi (optional - edit with your credentials)
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

# Start the service
sudo systemctl start bitcoin-display.service
```

**That’s it!** 🎉 Your display should now show the Bitcoin price.

### Interactive Hardware Setup

If you’re using different hardware than the recommended setup:

```bash
# Run the interactive setup wizard
python3 hardware_setup.py
```

This will guide you through:

- ✅ Platform selection (6 options)
- ✅ Display selection (6 options)
- ✅ Compatibility check
- ✅ Auto-configuration
- ✅ Wiring instructions

### Alternative: ESP32 Setup

For ESP32 boards (LILYGO T5, etc.):

```bash
cd esp32
# See detailed instructions
cat ESP32_SETUP.md
```

> 📚 **Need more help?** Check out our [detailed installation guide](INSTALLATION.md)

### Manuelle Installation

<details>
<summary>Klick hier für manuelle Schritte</summary>

#### 1. System aktualisieren

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

#### 2. Abhängigkeiten installieren

```bash
sudo apt-get install -y python3-pip python3-pil python3-numpy git
sudo apt-get install -y fonts-dejavu fonts-dejavu-core
```

#### 3. Python Bibliotheken

```bash
sudo pip3 install requests --break-system-packages
sudo pip3 install Pillow --break-system-packages
sudo pip3 install waveshare-epd --break-system-packages
```

#### 4. SPI aktivieren

```bash
sudo raspi-config
# Interface Options → SPI → Enable
sudo reboot
```

#### 5. Projekt installieren

```bash
cd ~
git clone https://github.com/yourusername/bitcoin-eink-display.git
cd bitcoin-eink-display
chmod +x bitcoin_display.py
```

</details>

## ⚙️ Konfiguration

### iPhone Hotspot einrichten

#### Auf dem iPhone:

1. **Einstellungen** → **Persönlicher Hotspot**
1. **“Zugriff für andere erlauben”** aktivieren
1. SSID und Passwort notieren

#### Auf dem Raspberry Pi:

```bash
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

Füge dein iPhone-Hotspot hinzu:

```conf
network={
    ssid="iPhone von Max"
    psk="dein-hotspot-passwort"
    key_mgmt=WPA-PSK
    priority=10
}
```

Speichern: `Strg+O`, `Enter`, `Strg+X`

WLAN neu starten:

```bash
sudo wpa_cli -i wlan0 reconfigure
```

Verbindung testen:

```bash
ping -c 4 8.8.8.8
```

### Autostart konfigurieren

Der Systemd Service wird automatisch erstellt:

```bash
# Service starten
sudo systemctl start bitcoin-display.service

# Status prüfen
sudo systemctl status bitcoin-display.service

# Autostart aktivieren
sudo systemctl enable bitcoin-display.service

# Logs ansehen
sudo journalctl -u bitcoin-display.service -f
```

## 🎨 Anpassungen

### Update-Intervall ändern

In `bitcoin_display.py`:

```python
UPDATE_INTERVAL = 300  # Sekunden (Standard: 5 Minuten)
```

Empfohlene Werte:

- **1 Minute:** 60 (viele Updates)
- **5 Minuten:** 300 (balanced, Standard)
- **15 Minuten:** 900 (energiesparend)
- **1 Stunde:** 3600 (minimaler Verbrauch)

### Alternative Kryptowährungen

Ändere in der Funktion `get_bitcoin_price()`:

```python
params = {
    'ids': 'ethereum',  # oder 'litecoin', 'cardano', etc.
    'vs_currencies': 'eur,usd',
    'include_24hr_change': 'true'
}
```

### Verschiedene Währungen

```python
params = {
    'ids': 'bitcoin',
    'vs_currencies': 'chf,gbp',  # Schweizer Franken, British Pound
    'include_24hr_change': 'true'
}
```

## 🔍 Troubleshooting

### Display zeigt nichts an

**SPI prüfen:**

```bash
ls /dev/spi*
# Sollte zeigen: /dev/spidev0.0 /dev/spidev0.1
```

Falls nicht:

```bash
sudo raspi-config
# Interface Options → SPI → Enable
sudo reboot
```

### Keine Internetverbindung

**WLAN Status:**

```bash
iwconfig wlan0
sudo wpa_cli status
```

**Verbindung neu aufbauen:**

```bash
sudo wpa_cli -i wlan0 reconfigure
sudo systemctl restart networking
```

**iPhone Hotspot:**

- Stelle sicher, dass “Maximale Kompatibilität” aktiviert ist
- Manchmal hilft: Hotspot aus/ein

### Service startet nicht

**Logs prüfen:**

```bash
sudo journalctl -u bitcoin-display.service -n 50 --no-pager
```

**Manuell testen:**

```bash
cd ~/bitcoin-eink-display
python3 bitcoin_display.py
```

## 🔋 Energieoptimierung

Für batteriebetriebenen Einsatz:

```bash
# HDMI deaktivieren (spart ~25mA)
sudo /opt/vc/bin/tvservice -o

# In /boot/config.txt:
# Bluetooth deaktivieren
dtoverlay=disable-bt

# LED deaktivieren
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
```

**Geschätzter Verbrauch:**

- Idle: ~100-150mA @ 5V (0.5-0.75W)
- Während Update: ~200-250mA @ 5V (1.0-1.25W)
- Mit Optimierungen: ~80mA @ 5V (0.4W)

## 📊 Projektstruktur

```
bitcoin-eink-display/
├── bitcoin_display.py      # Hauptprogramm
├── setup.sh                # Installations-Script
├── requirements.txt        # Python-Abhängigkeiten
├── LICENSE
└── README.md
```

## 🤝 Beitragen

Contributions sind willkommen! Bitte:

1. Fork das Repository
1. Erstelle einen Feature Branch
1. Commit deine Änderungen
1. Push zum Branch
1. Öffne einen Pull Request

## 📜 Changelog

### Version 1.0.0 (2024-03-05)

- ✨ Initial Release
- ✅ Waveshare 2.13” V4 Support
- ✅ Raspberry Pi Zero 2 W optimiert
- ✅ iPhone Hotspot Integration
- ✅ Systemd Service

## 📝 Lizenz

MIT License - siehe <LICENSE> Datei

## 🙏 Credits

- **Waveshare** - E-Ink Display Library
- **CoinGecko** - Kostenlose Crypto API
- **Raspberry Pi Foundation** - Hardware

-----

<div align="center">

**⭐ Wenn dir dieses Projekt gefällt, gib ihm einen Stern auf GitHub! ⭐**

Made with ❤️ for the crypto community

</div>
