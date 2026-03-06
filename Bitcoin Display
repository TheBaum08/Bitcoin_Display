#!/usr/bin/env python3

# -*- coding: utf-8 -*-

# “””
Bitcoin E-Ink Display - Main Application

Live cryptocurrency price tracking on Waveshare E-Ink displays.

Supported Hardware:
- Raspberry Pi Zero 2 W (recommended)
- Waveshare 2.13” E-Paper HAT V4 (recommended)
- See MULTI_HARDWARE.md for all supported platforms

Features:
- Auto-updates every 5 minutes (configurable)
- Dual currency display (EUR/USD)
- 24h price change indicators
- Energy-efficient E-Ink technology
- Automatic startup via systemd

Usage:
python3 bitcoin_display.py

Configuration:
Edit config.py to customize settings (optional)

Author: Bitcoin Display Contributors
License: MIT
Repository: https://github.com/yourusername/bitcoin-eink-display
“””

import sys
import os
import time
import requests
from datetime import datetime
from PIL import Image, ImageDraw, ImageFont
import logging

**version** = “1.0.0”
**author** = “Bitcoin Display Contributors”

# Logging Setup

logging.basicConfig(
level=logging.INFO,
format=’%(asctime)s - %(levelname)s - %(message)s’
)
logger = logging.getLogger(**name**)

# Waveshare E-Ink Library importieren

# Installiere mit: sudo pip3 install waveshare-epd –break-system-packages

try:
from waveshare_epd import epd2in13_V4
except ImportError:
logger.error(“Waveshare EPD Library nicht gefunden!”)
logger.error(“Installiere mit: sudo pip3 install waveshare-epd –break-system-packages”)
sys.exit(1)

class BitcoinDisplay:
“””
Main display controller for Bitcoin price tracking.

```
This class handles:
    - E-Ink display initialization and control
    - Bitcoin price API calls (CoinGecko)
    - Image rendering and layout
    - Display updates and cleanup

Attributes:
    epd: Waveshare E-Paper display driver instance
    width (int): Display width in pixels
    height (int): Display height in pixels

Example:
    >>> display = BitcoinDisplay()
    >>> display.update_display()
    >>> display.cleanup()
"""

def __init__(self):
    """
    Initialize E-Ink display with Waveshare V4 driver.
    
    Raises:
        ImportError: If waveshare_epd library is not installed
        Exception: If display initialization fails
    """
    try:
        self.epd = epd2in13_V4.EPD()
        logger.info("Initialisiere E-Ink Display V4...")
        self.epd.init()
        self.epd.Clear(0xFF)
        
        # Display Dimensionen (Waveshare 2.13" V4: 250x122)
        self.width = self.epd.height  # 250
        self.height = self.epd.width  # 122
        
        logger.info(f"Display V4 bereit: {self.width}x{self.height}")
    except Exception as e:
        logger.error(f"Fehler bei Display-Initialisierung: {e}")
        raise

def get_bitcoin_price(self):
    """
    Fetch current Bitcoin price from CoinGecko API.
    
    Uses the free CoinGecko API (no API key required).
    Rate limit: ~10-30 calls/minute
    
    Returns:
        dict: Bitcoin price data with structure:
            {
                'eur': float,      # Price in EUR
                'usd': float,      # Price in USD
                'change_24h': float # 24h percentage change
            }
        None: If API call fails or times out
    
    Raises:
        requests.exceptions.RequestException: Network errors
        
    Example:
        >>> btc_data = display.get_bitcoin_price()
        >>> print(f"BTC: €{btc_data['eur']:,.2f}")
        BTC: €88,234.50
    """
    try:
        url = "https://api.coingecko.com/api/v3/simple/price"
        params = {
            'ids': 'bitcoin',
            'vs_currencies': 'eur,usd',
            'include_24hr_change': 'true'
        }
        
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        btc_data = data['bitcoin']
        
        return {
            'eur': btc_data['eur'],
            'usd': btc_data['usd'],
            'change_24h': btc_data.get('eur_24h_change', 0)
        }
    
    except requests.exceptions.RequestException as e:
        logger.error(f"Fehler beim Abrufen der Bitcoin-Daten: {e}")
        return None
    except Exception as e:
        logger.error(f"Unerwarteter Fehler: {e}")
        return None

def create_display_image(self, btc_data):
    """Erstelle Bild für E-Ink Display"""
    # Erstelle neues Bild (schwarz/weiß)
    image = Image.new('1', (self.width, self.height), 255)  # 255 = weiß
    draw = ImageDraw.Draw(image)
    
    # Versuche verschiedene Schriftarten
    try:
        font_large = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 32)
        font_medium = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 24)
        font_small = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 16)
        font_tiny = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 12)
    except:
        logger.warning("TrueType Fonts nicht gefunden, verwende Standard-Font")
        font_large = ImageFont.load_default()
        font_medium = ImageFont.load_default()
        font_small = ImageFont.load_default()
        font_tiny = ImageFont.load_default()
    
    # Aktuelle Zeit
    now = datetime.now()
    time_str = now.strftime("%d.%m.%Y %H:%M")
    
    # Zeichne Inhalt
    y_pos = 5
    
    # Titel
    draw.text((10, y_pos), "BITCOIN (BTC)", font=font_small, fill=0)
    y_pos += 25
    
    # Linie
    draw.line([(10, y_pos), (self.width - 10, y_pos)], fill=0, width=1)
    y_pos += 10
    
    if btc_data:
        # EUR Preis
        eur_price = f"€ {btc_data['eur']:,.0f}".replace(',', '.')
        draw.text((10, y_pos), eur_price, font=font_large, fill=0)
        y_pos += 40
        
        # USD Preis
        usd_price = f"$ {btc_data['usd']:,.0f}".replace(',', '.')
        draw.text((10, y_pos), usd_price, font=font_medium, fill=0)
        
        # 24h Änderung
        change = btc_data['change_24h']
        change_symbol = "▲" if change >= 0 else "▼"
        change_text = f"{change_symbol} {abs(change):.2f}%"
        
        # Positioniere rechts
        bbox = draw.textbbox((0, 0), change_text, font=font_small)
        text_width = bbox[2] - bbox[0]
        draw.text((self.width - text_width - 10, y_pos + 5), 
                 change_text, font=font_small, fill=0)
        
        y_pos += 30
    else:
        draw.text((10, y_pos), "Keine Daten", font=font_medium, fill=0)
        y_pos += 35
    
    # Zeitstempel unten
    draw.text((10, self.height - 15), time_str, font=font_tiny, fill=0)
    
    return image

def update_display(self):
    """Aktualisiere Display mit aktuellem Bitcoin Kurs"""
    try:
        logger.info("Hole Bitcoin-Kurs...")
        btc_data = self.get_bitcoin_price()
        
        if btc_data:
            logger.info(f"BTC: €{btc_data['eur']:,.2f} | ${btc_data['usd']:,.2f} | 24h: {btc_data['change_24h']:.2f}%")
        
        logger.info("Erstelle Display-Bild...")
        image = self.create_display_image(btc_data)
        
        logger.info("Aktualisiere Display...")
        self.epd.display(self.epd.getbuffer(image))
        
        logger.info("Display aktualisiert!")
        return True
        
    except Exception as e:
        logger.error(f"Fehler beim Aktualisieren des Displays: {e}")
        return False

def cleanup(self):
    """Bereinige Display beim Beenden"""
    try:
        logger.info("Bereinige Display...")
        self.epd.Clear(0xFF)
        self.epd.sleep()
    except Exception as e:
        logger.error(f"Fehler beim Bereinigen: {e}")
```

def main():
“”“Hauptprogramm”””
display = None

```
try:
    display = BitcoinDisplay()
    
    # Update Intervall in Sekunden (5 Minuten)
    UPDATE_INTERVAL = 300
    
    logger.info(f"Bitcoin Display gestartet (Update alle {UPDATE_INTERVAL}s)")
    logger.info("Drücke Ctrl+C zum Beenden")
    
    while True:
        display.update_display()
        
        # Warte bis zum nächsten Update
        logger.info(f"Warte {UPDATE_INTERVAL} Sekunden bis zum nächsten Update...")
        time.sleep(UPDATE_INTERVAL)

except KeyboardInterrupt:
    logger.info("\nProgramm wird beendet...")

except Exception as e:
    logger.error(f"Fehler: {e}")

finally:
    if display:
        display.cleanup()
    logger.info("Programm beendet")
```

if **name** == ‘**main**’:
main()
