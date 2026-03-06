# Detaillierte Installationsanleitung

## Vorbereitung

### Was du brauchst

- ✅ Raspberry Pi Zero 2 W
- ✅ Waveshare 2.13” E-Paper HAT V4
- ✅ microSD Karte (8GB+, Class 10)
- ✅ USB Netzteil (5V/2A)
- ✅ Micro-USB Kabel
- ✅ Computer mit SD-Kartenleser
- ✅ iPhone mit Hotspot (oder Router)

### Optional

- Mini-HDMI Adapter (für Ersteinrichtung)
- USB-Hub (Tastatur + Maus)
- Gehäuse / Halterung

-----

## Schritt 1: Raspberry Pi OS installieren

### 1.1 Raspberry Pi Imager herunterladen

**Download:**

- [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
- Verfügbar für Windows, macOS, Linux

### 1.2 OS Image schreiben

1. **Imager starten**
1. **“Choose OS”** klicken
- Raspberry Pi OS (other)
- **Raspberry Pi OS Lite (64-bit)** auswählen

> **Warum Lite?** Kein Desktop nötig, spart Speicher & Strom
1. **“Choose Storage”** → deine SD-Karte auswählen
1. **⚙️ Zahnrad-Symbol** klicken (Erweiterte Optionen)
   
   Konfiguriere:
- ✅ **Set hostname:** `bitcoin-display` (optional)
- ✅ **Enable SSH:** Ja, mit Passwort
- ✅ **Set username and password:**
  - Username: `pi`
  - Password: `dein-sicheres-passwort`
- ✅ **Configure wireless LAN:** (Optional, falls kein iPhone Hotspot)
  - SSID: Dein WLAN Name
  - Password: Dein WLAN Passwort
  - Country: `DE`
- ✅ **Set locale settings:**
  - Timezone: `Europe/Berlin`
  - Keyboard: `de`
1. **Write** klicken & bestätigen

⏱️ Dauer: ~5-10 Minuten

### 1.3 SD-Karte einlegen & starten

1. SD-Karte in Pi Zero 2 W einlegen
1. Display **NOCH NICHT** aufstecken
1. Micro-USB Kabel anschließen (Port: “PWR IN”, nicht “USB”)
1. Pi sollte booten (grüne LED blinkt)

⏱️ Erster Boot: ~1-2 Minuten

-----

## Schritt 2: SSH Verbindung

### 2.1 IP-Adresse finden

**Option A: Router Interface**

- Router-Admin öffnen (meist 192.168.1.1)
- DHCP Client Liste
- Suche nach “bitcoin-display” oder “raspberrypi”

**Option B: Network Scanner**

```bash
# macOS/Linux
arp -a | grep -i raspberry

# Windows
arp -a | findstr /i "b8-27-eb dc-a6-32 e4-5f-01"
```

**Option C: Angry IP Scanner**

- [Download](https://angryip.org/)
- Scanne lokales Netzwerk (192.168.1.0/24)

### 2.2 SSH Verbindung herstellen

**macOS / Linux:**

```bash
ssh pi@192.168.1.XXX
# Passwort eingeben
```

**Windows:**

- [PuTTY](https://www.putty.org/) herunterladen
- Host: `192.168.1.XXX`
- Port: `22`
- Connection Type: SSH
- Open → Passwort eingeben

**Erster Login:**

```
The authenticity of host ... can't be established.
Are you sure you want to continue? yes
```

✅ Erfolgreich wenn du den Prompt siehst: `pi@bitcoin-display:~ $`

-----

## Schritt 3: System Update

```bash
# System aktualisieren
sudo apt-get update
sudo apt-get upgrade -y

# Neustart (falls Kernel Updates)
sudo reboot
```

⏱️ Dauer: ~10-20 Minuten (abhängig von Updates)

**Nach Reboot:** Erneut per SSH verbinden

-----

## Schritt 4: Git & Python installieren

```bash
# Basis-Pakete
sudo apt-get install -y git python3-pip python3-pil python3-numpy

# Fonts (für schöne Anzeige)
sudo apt-get install -y fonts-dejavu fonts-dejavu-core
```

**Überprüfung:**

```bash
python3 --version  # Sollte Python 3.9+ zeigen
git --version      # Git Version
```

-----

## Schritt 5: SPI Interface aktivieren

### 5.1 Config öffnen

```bash
sudo raspi-config
```

### 5.2 Navigation

```
Interface Options
  → SPI
    → Would you like the SPI interface to be enabled?
      → <Yes>
```

### 5.3 Reboot

```bash
sudo reboot
```

### 5.4 Verifizierung (nach Reboot)

```bash
ls /dev/spi*
```

**Erwartete Ausgabe:**

```
/dev/spidev0.0  /dev/spidev0.1
```

✅ SPI ist aktiviert!

-----

## Schritt 6: Python Libraries installieren

```bash
# Requests (für API Calls)
sudo pip3 install requests --break-system-packages

# Pillow (Bildverarbeitung)
sudo pip3 install Pillow --break-system-packages

# Waveshare E-Paper Library
sudo pip3 install waveshare-epd --break-system-packages
```

> **Hinweis:** `--break-system-packages` ist nötig ab Debian 12 (Bookworm)

**Alternative (manuelle Installation):**

```bash
cd /tmp
git clone https://github.com/waveshare/e-Paper.git
cd e-Paper/RaspberryPi_JetsonNano/python
sudo python3 setup.py install
```

-----

## Schritt 7: Projekt installieren

### 7.1 Repository klonen

```bash
cd ~
git clone https://github.com/DEIN-USERNAME/bitcoin-eink-display.git
cd bitcoin-eink-display
```

**Oder manuell herunterladen:**

```bash
mkdir ~/bitcoin-eink-display
cd ~/bitcoin-eink-display

# Dateien per SCP hochladen:
# scp bitcoin_display.py pi@192.168.1.XXX:~/bitcoin-eink-display/
```

### 7.2 Ausführbar machen

```bash
chmod +x bitcoin_display.py
chmod +x setup.sh  # Falls vorhanden
```

### 7.3 Test ohne Display

```bash
python3 bitcoin_display.py
```

**Erwartete Fehler:**

```
Failed to open device '/dev/spidev0.0': No such device
```

Das ist OK - Display ist noch nicht angeschlossen!

Drücke `Ctrl+C` zum Beenden.

-----

## Schritt 8: Display anschließen

⚠️ **WICHTIG: Pi ausschalten vor dem Anschließen!**

```bash
sudo shutdown -h now
```

Warte bis grüne LED aus ist (10 Sekunden).

### 8.1 Display aufstecken

1. Vom Strom trennen
1. Display vorsichtig auf GPIO-Pins aufsetzen
1. Gleichmäßig andrücken
1. Alle Pins müssen vollständig drin sein

### 8.2 Visueller Check

- Display sitzt parallel zur Platine
- Keine verbogenen Pins
- Fester Sitz

### 8.3 Strom wieder anschließen

Pi bootet automatisch.

-----

## Schritt 9: Ersten Test

### 9.1 SSH Verbindung

```bash
ssh pi@192.168.1.XXX
cd ~/bitcoin-eink-display
```

### 9.2 Programm starten

```bash
python3 bitcoin_display.py
```

**Erwartete Ausgabe:**

```
INFO - Initialisiere E-Ink Display V4...
INFO - Display V4 bereit: 250x122
INFO - Hole Bitcoin-Kurs...
INFO - BTC: €XX,XXX.XX | $XX,XXX.XX | 24h: X.XX%
INFO - Erstelle Display-Bild...
INFO - Aktualisiere Display...
INFO - Display aktualisiert!
```

✅ **Erfolg!** Das Display sollte jetzt den Bitcoin-Kurs anzeigen!

### 9.3 Programm stoppen

Drücke `Ctrl+C`

```
Program wird beendet...
Bereinige Display...
Programm beendet
```

-----

## Schritt 10: iPhone Hotspot einrichten

### 10.1 iPhone konfigurieren

1. **Einstellungen** öffnen
1. **Persönlicher Hotspot**
1. **“Zugriff für andere erlauben”** aktivieren
1. **WLAN-Passwort** notieren
1. **“Maximale Kompatibilität”** aktivieren (wichtig!)

### 10.2 WLAN auf Pi konfigurieren

```bash
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

**Füge hinzu** (am Ende der Datei):

```conf
network={
    ssid="iPhone von Max"
    psk="dein-hotspot-passwort"
    key_mgmt=WPA-PSK
    priority=10
}
```

Speichern: `Strg+O`, `Enter`, `Strg+X`

### 10.3 WLAN neu verbinden

```bash
sudo wpa_cli -i wlan0 reconfigure
```

### 10.4 Verbindung testen

```bash
# Status prüfen
iwconfig wlan0

# Internet testen
ping -c 4 8.8.8.8

# Hostname auflösung
ping -c 4 google.com
```

✅ Wenn Pakete ankommen: Internet funktioniert!

-----

## Schritt 11: Autostart einrichten

### 11.1 Systemd Service erstellen

```bash
sudo nano /etc/systemd/system/bitcoin-display.service
```

**Inhalt:**

```ini
[Unit]
Description=Bitcoin E-Ink Display
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/bitcoin-eink-display
ExecStart=/usr/bin/python3 /home/pi/bitcoin-eink-display/bitcoin_display.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Speichern: `Strg+O`, `Enter`, `Strg+X`

### 11.2 Service aktivieren

```bash
# Daemon neu laden
sudo systemctl daemon-reload

# Service aktivieren (Autostart)
sudo systemctl enable bitcoin-display.service

# Service starten
sudo systemctl start bitcoin-display.service
```

### 11.3 Status prüfen

```bash
sudo systemctl status bitcoin-display.service
```

**Erwartete Ausgabe:**

```
● bitcoin-display.service - Bitcoin E-Ink Display
   Loaded: loaded
   Active: active (running)
   ...
```

✅ **Status “active (running)”** = Läuft!

### 11.4 Logs ansehen

```bash
# Live Logs (Ctrl+C zum Beenden)
sudo journalctl -u bitcoin-display.service -f

# Letzte 50 Zeilen
sudo journalctl -u bitcoin-display.service -n 50
```

-----

## Schritt 12: Finaler Test

### 12.1 Reboot

```bash
sudo reboot
```

### 12.2 Nach Reboot prüfen

Warte 2 Minuten, dann:

```bash
ssh pi@192.168.1.XXX
sudo systemctl status bitcoin-display.service
```

✅ Sollte automatisch laufen!

### 12.3 Display prüfen

- Zeigt Bitcoin-Kurs?
- EUR & USD Preise sichtbar?
- 24h Änderung angezeigt?
- Zeitstempel aktuell?

-----

## Fertig! 🎉

Dein Bitcoin Display läuft jetzt und:

- ✅ Startet automatisch beim Booten
- ✅ Aktualisiert alle 5 Minuten
- ✅ Verbindet sich automatisch mit iPhone Hotspot
- ✅ Läuft 24/7

-----

## Nächste Schritte

### Anpassungen vornehmen

```bash
cd ~/bitcoin-eink-display
nano bitcoin_display.py

# Nach Änderungen:
sudo systemctl restart bitcoin-display.service
```

### Andere Kryptowährung

Siehe <README.md> - Sektion “Anpassungen”

### Gehäuse bauen

- [Thingiverse](https://www.thingiverse.com) - Suche “Raspberry Pi Zero E-Ink”
- Eigenes Design mit FreeCAD/Fusion360

### Monitoring

```bash
# CPU Temperatur
vcgencmd measure_temp

# Stromverbrauch prüfen
vcgencmd get_throttled

# Logs
sudo journalctl -u bitcoin-display.service --since today
```

-----

## Hilfe & Support

**Probleme?** Siehe <README.md> - Sektion “Troubleshooting”

**Logs prüfen:**

```bash
sudo journalctl -u bitcoin-display.service -n 100
```

**Service neu starten:**

```bash
sudo systemctl restart bitcoin-display.service
```

**GitHub Issues:** [Hier melden](https://github.com/DEIN-USERNAME/bitcoin-eink-display/issues)
