# Häufig gestellte Fragen (FAQ)

## Allgemein

### Welche Kosten entstehen?

**Hardware:** ~60€ (Pi Zero 2 W + Display + Zubehör)
**Software:** Kostenlos & Open Source
**API:** CoinGecko Free API - keine Kosten
**Strom:** ~1W = ~2€/Jahr bei 0.30€/kWh

### Kann ich andere Kryptowährungen anzeigen?

Ja! In `bitcoin_display.py` ändern:

```python
params = {
    'ids': 'ethereum',  # oder litecoin, cardano, dogecoin, etc.
    'vs_currencies': 'eur,usd',
    'include_24hr_change': 'true'
}
```

Verfügbare Coins: https://api.coingecko.com/api/v3/coins/list

### Funktioniert es ohne iPhone Hotspot?

Ja! Jedes WLAN funktioniert. iPhone Hotspot ist nur ein Beispiel.
Du kannst auch klassisches WLAN, Router, oder mobilen Hotspot nutzen.

### Wie lange hält das Display?

E-Ink Displays halten typischerweise >1 Million Refreshes.
Bei 5-Minuten Updates: **>9 Jahre Lebensdauer**

Hauptproblem ist UV-Schäden - nicht in direkte Sonne stellen!

### Kann ich mehrere Displays betreiben?

Ja, aber nicht an einem Pi. Jedes Display braucht einen eigenen Pi.
Alternativ: Größeres Display (7.5”) nutzen für mehr Informationen.

-----

## Installation

### SPI lässt sich nicht aktivieren?

```bash
# Manuell in config.txt eintragen:
sudo nano /boot/config.txt

# Hinzufügen:
dtparam=spi=on

# Speichern und Reboot
sudo reboot

# Prüfen:
ls /dev/spi*
```

### Waveshare Library Installation schlägt fehl?

**Lösung 1:** Manuelle Installation

```bash
cd /tmp
git clone https://github.com/waveshare/e-Paper.git
cd e-Paper/RaspberryPi_JetsonNano/python
sudo python3 setup.py install
```

**Lösung 2:** Direkt aus GitHub

```bash
sudo pip3 install git+https://github.com/waveshare/e-Paper.git#subdirectory=RaspberryPi_JetsonNano/python --break-system-packages
```

### “Permission denied” Fehler?

```bash
# User zu GPIO/SPI Gruppen hinzufügen:
sudo usermod -a -G spi,gpio $USER

# Neu einloggen (logout/login) oder:
newgrp spi
newgrp gpio
```

-----

## Hardware

### Welches Display-Modell brauche ich?

**Empfohlen:** Waveshare 2.13” E-Paper HAT V4

- Schnellere Refreshes
- Flash-Memory
- Beste Kompatibilität

**Funktioniert auch:**

- V3 (mit Code-Anpassung: `epd2in13_V3`)
- Andere Größen: 2.9”, 4.2”, 7.5” (mit Anpassungen)

### GPIO Pins sind nicht verlötet?

Du brauchst einen **40-Pin Male GPIO Header**:

1. Header kaufen (~2€)
1. Mit Lötkolben auflöten (60W+)
1. Auf festen Sitz prüfen

Alternative: Raspberry Pi Zero 2 WH (mit vorgelötetem Header kaufen)

### Display zeigt Geisterbilder (Ghosting)?

**Ursache:** Unvollständige Refreshes
**Lösung:**

```python
# Full Clear durchführen
epd.init()
epd.Clear(0xFF)
time.sleep(2)
epd.Clear(0x00)
time.sleep(2)
epd.Clear(0xFF)
```

Oder Service neu starten:

```bash
sudo systemctl restart bitcoin-display.service
```

### Kann ich es mit Batterie betreiben?

Ja! Optionen:

**USB Powerbank:**

- ✅ Einfach
- ❌ Auto-Shutdown bei geringem Verbrauch
- Laufzeit: ~100-150h

**LiPo + Boost Converter:**

- ✅ Kompakt
- ✅ Langlebig
- ❌ Etwas komplexer
- Laufzeit: ~20-40h

**4× AA Batterien:**

- ✅ Günstig
- ❌ Groß
- Laufzeit: ~10-20h

-----

## Netzwerk

### Pi verbindet sich nicht mit iPhone Hotspot?

**Check 1:** “Maximale Kompatibilität” aktivieren

- iPhone: Einstellungen → Persönlicher Hotspot
- “Maximale Kompatibilität” AN

**Check 2:** Passwort richtig?

```bash
sudo wpa_cli -i wlan0 reconfigure
sudo wpa_cli status
```

**Check 3:** 5GHz Problem?
Pi Zero 2 W unterstützt nur 2.4GHz!

- iPhone Hotspot sollte automatisch 2.4GHz nutzen
- Falls nicht: In iPhone WLAN-Einstellungen forcieren

### Verbindung bricht ständig ab?

**Stromspar-Modus deaktivieren:**

```bash
sudo nano /etc/rc.local

# Vor "exit 0" hinzufügen:
/sbin/iwconfig wlan0 power off

# Speichern und Reboot
sudo reboot
```

### Statische IP zuweisen?

```bash
sudo nano /etc/dhcpcd.conf

# Hinzufügen:
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=8.8.8.8

# Speichern und neu starten:
sudo systemctl restart dhcpcd
```

-----

## Display

### Display bleibt komplett schwarz?

**Check 1:** Stromversorgung

```bash
vcgencmd get_throttled
# 0x0 = OK, alles andere = Problem
```

**Check 2:** SPI aktiv?

```bash
ls /dev/spi*
# Sollte /dev/spidev0.0 zeigen
```

**Check 3:** Verkabelung

- Display fest aufgesteckt?
- Alle Pins drin?
- Keine verbogenen Pins?

**Check 4:** Manueller Test

```bash
cd ~/bitcoin-eink-display
python3 bitcoin_display.py
```

### Display reagiert sehr langsam?

**Normal:** E-Ink braucht 2-3 Sekunden zum Refresh
**Zu langsam (>10s):**

- Temperatur prüfen (funktioniert nicht <0°C)
- Display Reset durchführen

### Kann ich Farben nutzen?

Nein, das 2.13” V4 ist nur Schwarz/Weiß.

Für Farbe brauchst du:

- Waveshare 2.13” (B/C) - Rot/Schwarz/Weiß
- Code-Anpassungen für Farb-Display

-----

## API & Updates

### Wie oft kann ich Updates machen?

**CoinGecko Free API:** 10-30 Calls/Minute

**Empfohlen:**

- 5 Minuten (Standard) - sicher
- 1 Minute - möglich, aber an der Grenze
- <1 Minute - NICHT empfohlen (Rate Limit!)

### API antwortet nicht / Fehler 429?

**Fehler 429 = Rate Limit**

```bash
# Update-Intervall erhöhen in bitcoin_display.py:
UPDATE_INTERVAL = 600  # 10 Minuten statt 5
```

**Kein Internet:**

```bash
ping -c 4 8.8.8.8
# Wenn OK → DNS Problem
ping -c 4 google.com
```

### Alternative APIs?

**Binance:**

```python
url = "https://api.binance.com/api/v3/ticker/24hr"
params = {'symbol': 'BTCEUR'}
```

**CoinMarketCap:**

- Braucht API-Key (kostenlos verfügbar)
- https://coinmarketcap.com/api/

**Kraken:**

```python
url = "https://api.kraken.com/0/public/Ticker"
params = {'pair': 'XBTEUR'}
```

-----

## Service & Autostart

### Service startet nicht automatisch?

```bash
# Check Autostart-Status:
sudo systemctl is-enabled bitcoin-display.service

# Falls "disabled":
sudo systemctl enable bitcoin-display.service

# Nach Reboot testen:
sudo reboot
```

### Service crasht ständig?

**Logs prüfen:**

```bash
sudo journalctl -u bitcoin-display.service -n 100
```

Häufige Ursachen:

- Keine Internet-Verbindung
- Display nicht angeschlossen
- SPI nicht aktiv
- Python-Library fehlt

### Programm manuell stoppen?

```bash
# Service stoppen:
sudo systemctl stop bitcoin-display.service

# Autostart deaktivieren:
sudo systemctl disable bitcoin-display.service
```

-----

## Anpassungen

### Wie ändere ich das Design?

In `bitcoin_display.py` → Funktion `create_display_image()`:

```python
# Fonts ändern:
font_large = ImageFont.truetype('...', 40)  # Größer

# Layout ändern:
y_pos = 10  # Startposition
draw.text((x, y_pos), "Text", font=font, fill=0)

# Linien/Formen:
draw.line([(x1,y1), (x2,y2)], fill=0, width=2)
draw.rectangle([(x1,y1), (x2,y2)], outline=0, fill=255)
```

### Kann ich Grafiken/Charts hinzufügen?

Ja! Matplotlib installieren:

```bash
sudo pip3 install matplotlib --break-system-packages
```

Dann in Python:

```python
import matplotlib.pyplot as plt
# Chart erstellen & als Bild in Display einfügen
```

### Mehrere Währungen gleichzeitig anzeigen?

```python
params = {
    'ids': 'bitcoin,ethereum,cardano',
    'vs_currencies': 'eur',
    'include_24hr_change': 'true'
}
# Dann Layout anpassen für 3 Coins
```

-----

## Sonstiges

### Wie viel Strom verbraucht es?

**Messung:**

- Idle: ~0.5W
- Während Refresh: ~1.0W
- **Durchschnitt: ~0.75W**

**Kosten pro Jahr:**

- 0.75W × 24h × 365 Tage = 6.57 kWh
- Bei 0.30€/kWh = **~2€/Jahr**

### Kann ich es draußen nutzen?

**Eingeschränkt möglich:**

- ✅ Temperatur: 0-50°C
- ❌ Direkte Sonne (UV-Schäden)
- ❌ Regen/Feuchtigkeit
- ✅ Überdacht/Geschützt: OK

**Besser:** Indoor oder in wetterfestem Gehäuse

### Wo finde ich Gehäuse?

**3D-Druck:**

- Thingiverse.com - Suche “Raspberry Pi Zero E-Ink”
- Printables.com - Viele Designs
- Eigenes Design mit FreeCAD/Fusion360

**Kaufen:**

- Offizielles Pi Zero Case (modifizieren)
- Hammond Kunststoffgehäuse
- Custom Acryl-Case

### Läuft es auch auf anderen Raspberry Pis?

**Ja, funktioniert auf:**

- ✅ Pi Zero W (langsamer, aber günstiger)
- ✅ Pi Zero 2 W (empfohlen)
- ✅ Pi 3/4/5 (oversized, aber funktioniert)
- ✅ Pi 400 (ungewöhnlich, aber möglich)

**Code-Änderungen:** Keine nötig!

-----

## Weitere Hilfe

**Nicht gefunden?**

- [GitHub Issues](https://github.com/DEIN-USERNAME/bitcoin-eink-display/issues)
- [GitHub Discussions](https://github.com/DEIN-USERNAME/bitcoin-eink-display/discussions)
- Logs posten: `sudo journalctl -u bitcoin-display.service -n 100`
