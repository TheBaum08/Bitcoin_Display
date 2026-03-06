# Hardware Dokumentation

## Komponenten Details

### Raspberry Pi Zero 2 W

**Spezifikationen:**

- **CPU:** Broadcom BCM2710A1, quad-core 64-bit ARM Cortex-A53 @ 1GHz
- **RAM:** 512MB LPDDR2
- **WLAN:** 2.4GHz IEEE 802.11 b/g/n
- **Bluetooth:** 4.2, BLE
- **GPIO:** 40-Pin Header
- **Stromverbrauch:** ~0.4W idle, ~1.2W unter Last
- **Abmessungen:** 65mm × 30mm

**Warum Zero 2 W?**

- ✅ Eingebautes WLAN für iPhone Hotspot
- ✅ Ausreichend Rechenleistung für Python
- ✅ Sehr energieeffizient
- ✅ Kompakte Bauform
- ✅ Günstiger Preis

**Alternative:** Raspberry Pi Zero W (langsamer, aber günstiger)

### Waveshare 2.13” E-Paper HAT V4

**Technische Daten:**

- **Modell:** 2.13inch e-Paper HAT (V4)
- **Auflösung:** 250 × 122 Pixel
- **Farben:** Schwarz/Weiß (1-Bit)
- **Graustufen:** Keine
- **Interface:** SPI
- **Refresh-Zeit:** ~2 Sekunden (Full), ~0.5s (Partial)
- **Viewing Angle:** >170°
- **Stromverbrauch:**
  - Refresh: ~26.4mW
  - Standby: ~0.017mW (praktisch 0)
- **Betriebstemperatur:** 0~50°C
- **Lagertemperatur:** -25~60°C

**Unterschiede V3 vs V4:**

|Feature        |V3    |V4    |
|---------------|------|------|
|Partial Refresh|❌ Nein|✅ Ja  |
|Refresh Zeit   |2s    |0.5-2s|
|Flash Memory   |❌     |✅ Ja  |
|Preis          |~15€  |~20€  |

**Warum V4?**

- Schnellere Partial Refreshes möglich
- Integrierter Flash-Speicher
- Modernerer Controller
- Bessere Langzeitstabilität

### GPIO Pin-Belegung (detailliert)

```
Raspberry Pi Zero 2 W GPIO Layout:

     3V3  (1) (2)  5V
   GPIO2  (3) (4)  5V
   GPIO3  (5) (6)  GND
   GPIO4  (7) (8)  GPIO14
     GND  (9) (10) GPIO15
  GPIO17 (11) (12) GPIO18
  GPIO27 (13) (14) GND
  GPIO22 (15) (16) GPIO23
     3V3 (17) (18) GPIO24  ← BUSY
  GPIO10 (19) (20) GND     ← DIN (MOSI)
   GPIO9 (21) (22) GPIO25  ← DC
  GPIO11 (23) (24) GPIO8   ← CLK (SCLK), CS
     GND (25) (26) GPIO7
   GPIO0 (27) (28) GPIO1
   GPIO5 (29) (30) GND
   GPIO6 (31) (32) GPIO12
  GPIO13 (33) (34) GND
  GPIO19 (35) (36) GPIO16
  GPIO26 (37) (38) GPIO20
     GND (39) (40) GPIO21
```

**E-Ink Display Verbindungen:**

```
Display Pin → BCM GPIO → Physical Pin
VCC         → 3.3V     → Pin 1
GND         → GND      → Pin 6
DIN         → GPIO10   → Pin 19 (MOSI)
CLK         → GPIO11   → Pin 23 (SCLK)
CS          → GPIO8    → Pin 24 (CE0)
DC          → GPIO25   → Pin 22
RST         → GPIO17   → Pin 11
BUSY        → GPIO24   → Pin 18
```

## Assembly Anleitung

### Schritt 1: GPIO Header (falls nötig)

Falls dein Pi Zero 2 W keine aufgelöteten GPIO Pins hat:

1. 40-Pin Header kaufen
1. Mit Lötkolben (60W+) auflöten
1. Alle 40 Pins durchlöten
1. Auf festen Sitz prüfen

**Tipp:** Male GPIO Header sind einfacher für HATs

### Schritt 2: Display aufstecken

1. Pi Zero ausschalten & vom Strom trennen
1. Display vorsichtig auf GPIO aufsetzen
1. Gleichmäßig nach unten drücken
1. Alle Pins müssen vollständig eingesteckt sein
1. Display sollte parallel zur Platine sitzen

**WARNUNG:**

- ⚠️ Keine Gewalt anwenden
- ⚠️ Auf richtige Ausrichtung achten
- ⚠️ Pin 1 (3.3V) muss zu Pin 1 passen

### Schritt 3: Montage (Optional)

**3D-Druck Gehäuse:**

- Thingiverse: Suche “Raspberry Pi Zero E-Ink”
- Empfehlung: PLA, 0.2mm Layer Height
- Benötigt: M2.5 Schrauben

**Wandmontage:**

- Doppelseitiges Klebeband (3M VHB)
- Command Strips
- Mini-Schrauben in Wanddübel

## Stromversorgung

### Empfohlene Netzteile

**Mindestanforderung:**

- **Spannung:** 5V ±5%
- **Strom:** Mindestens 1A, empfohlen 2A
- **Anschluss:** Micro-USB

**Empfohlene Modelle:**

- Offizielles Raspberry Pi Netzteil (5V/2.5A)
- Anker PowerPort
- Qualitäts-USB-Ladegerät (≥2A)

**NICHT verwenden:**

- ❌ Billig-Netzteile ohne CE
- ❌ USB-Ports von PCs (instabil)
- ❌ Alte Handy-Ladegeräte (<1A)

### Batteriebetrieb

**Option 1: USB Powerbank**

- Kapazität: 10.000mAh
- Laufzeit: ~100-150h @ 5min Updates
- Problem: Auto-Shutdown bei geringem Verbrauch

**Option 2: LiPo mit Step-Up**

- 3.7V LiPo Akku (z.B. 18650)
- Step-Up Converter zu 5V
- Laufzeit: ~20-40h @ 10.000mAh

**Option 3: 4× AA Batterien**

- Mit DC-DC Boost Converter
- ~6V → 5V reguliert
- Günstige Lösung

## Umgebungsbedingungen

**Optimal:**

- Temperatur: 15-25°C
- Luftfeuchtigkeit: 30-60%
- Keine direkte Sonneneinstrahlung
- Innenraum

**Grenzwerte:**

- Betrieb: 0-50°C
- Lagerung: -25-60°C
- Max. Luftfeuchtigkeit: 90% (nicht kondensierend)

**Probleme bei Extremen:**

- **Unter 0°C:** E-Ink Refresh sehr langsam/unmöglich
- **Über 50°C:** Beschädigung des E-Ink Displays
- **Hohe Luftfeuchtigkeit:** Korrosion, Kurzschlüsse

## Wartung

### Regelmäßige Checks (monatlich)

✅ Stromkabel fest verbunden?
✅ Display-HAT sitzt fest?
✅ Keine Verfärbungen am Display?
✅ Logs auf Fehler prüfen

### E-Ink Display Pflege

**Reinigung:**

- Trockenes Mikrofasertuch
- NIEMALS nass abwischen
- Keine Reinigungsmittel
- Kein Druck auf Display

**Ghosting vermeiden:**

- Bei langem Stillstand: Refresh durchführen
- Alle paar Tage kompletten Clear-Cycle

**Lebensdauer:**

- Typisch: >1 Million Refreshes
- Bei 5min Updates: >9 Jahre
- Hauptproblem: UV-Schäden

## Troubleshooting Hardware

### Display zeigt nichts

**Check 1: Stromversorgung**

```bash
vcgencmd get_throttled
# 0x0 = OK, alles andere = Problem
```

**Check 2: SPI Interface**

```bash
ls /dev/spi*
# Sollte zeigen: /dev/spidev0.0 /dev/spidev0.1
```

**Check 3: GPIO Belegung**

```bash
gpio readall
# Zeigt alle Pin-Status
```

### Display hat Artefakte

**Ursachen:**

1. Unvollständiger Refresh
1. Stromversorgung instabil
1. Temperatur außerhalb Spec
1. Display-Controller Fehler

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

### Pi startet nicht

**LED-Codes:**

- **Grüne LED blinkt:** SD-Karte Fehler
- **Keine LED:** Keine Stromversorgung
- **Rote LED dauerhaft:** Unterspannung

**Diagnose:**

1. Andere SD-Karte testen
1. Anderes Netzteil testen
1. Display entfernen & neu starten
1. GPIO auf Kurzschlüsse prüfen

## Erweiterungen

### Zusätzliche Sensoren

**BME280 (Temperatur/Luftdruck/Feuchtigkeit):**

- I2C Interface (Pin 3, 5)
- Zeigt lokales Wetter

**BH1750 (Lichtsensor):**

- I2C Interface
- Auto-Helligkeit (für zukünftige Displays)

### Andere Displays

**Kompatible Waveshare Modelle:**

- 2.9” (296×128) - größer, gleicher Code
- 4.2” (400×300) - viel größer
- 7.5” (800×480) - sehr groß

**Code-Anpassung:**

```python
from waveshare_epd import epd2in9_V2  # Statt epd2in13_V4
self.width = self.epd.height
self.height = self.epd.width
```

## Technische Referenzen

- [Waveshare Wiki](https://www.waveshare.com/wiki/2.13inch_e-Paper_HAT_(D))
- [Pi Zero 2 W Datenblatt](https://datasheets.raspberrypi.com/rpizero2/raspberry-pi-zero-2-w-product-brief.pdf)
- [BCM2710 Dokumentation](https://www.raspberrypi.com/documentation/computers/processors.html)
- [SPI Interface](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#serial-peripheral-interface-spi)
