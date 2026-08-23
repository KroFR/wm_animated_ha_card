# 🧺 Animierte Waschmaschinen-Karte für Home Assistant

[English](README.md) | [Русский](README_RU.md) | **Deutsch**

Eine von Oikos inspirierte Lovelace-Karte, die aus einer *gewöhnlichen* Waschmaschine an einer smarten Steckdose ein schönes, animiertes Dashboard-Widget macht — ganz ohne smarte Waschmaschine.

![Demo](media/demo_en.gif)

<sub>Demo mit russischer Oberfläche (auf einem echten Dashboard aufgenommen): [media/demo.gif](media/demo.gif) · [media/demo.mp4](media/demo.mp4)</sub>

## ✨ Funktionen

- **Animierte Maschine** — während eines Durchgangs purzelt die Wäsche hinter dem Glas, blaue Bögen drehen sich um die Tür (eine Umdrehung in 3 s) und das Display an der Maschine zeigt die verstrichene Zeit. Die gesamte Animation ist reines CSS/SVG, ohne externe Dateien, und berücksichtigt `prefers-reduced-motion`.
- **Live-Status** — ein pulsierendes „LÄUFT / BEREIT“-Badge, ein Ring mit der verstrichenen Zeit und eine Leistungsanzeige mit automatischer Einheitenwahl (`1950 W` wird als `1,95 kW` angezeigt; bei einem Stromsensor lautet die Beschriftung automatisch „Stromaufnahme“).
- **Zusammenfassung des letzten Durchgangs** — Startzeit („Heute, 09:55“), Dauer, Verbrauch und Kosten; jede Spalte öffnet per Tippen den More-Info-Dialog.
- **Schnellzugriffe** — Schaltflächen in der Kopfzeile schalten die smarte Steckdose und die Benachrichtigungs-Automatisierung und öffnen den Leistungsverlauf.
- **Drei Sprachen** — Deutsch, Englisch und Russisch von Haus aus. Die Sprache folgt deinem Home-Assistant-Profil oder wird mit `language: de | en | ru` fest gesetzt.
- **Ohne Abhängigkeiten** — eine einzige Vanilla-JS-Datei mit Shadow DOM. Alle Entity-Optionen außer `status_entity` sind optional: Blöcke ohne Entity werden einfach ausgeblendet. Responsiv über CSS Container Queries.

## 📦 Installation

### Manuell

1. Kopiere [`washing-machine-card.js`](washing-machine-card.js) nach `/config/www/`.
2. Füge eine Dashboard-Ressource hinzu (Einstellungen → Dashboards → Ressourcen oder `lovelace: resources:` im YAML-Modus):

   ```yaml
   url: /local/washing-machine-card.js?v=1
   type: module
   ```

   Erhöhe `?v=` nach jedem Update, um den Browser-Cache zu leeren.

### HACS

Füge `https://github.com/sionetta/wm_animated_ha_card` als **benutzerdefiniertes Repository** hinzu (Typ: Dashboard) und installiere *Washing Machine Animated Card*.

## ⚙️ Konfiguration

```yaml
type: custom:washing-machine-card
name: Waschmaschine
status_entity: binary_sensor.washing_in_progress   # ERFORDERLICH
plug_entity: switch.washing_machine_plug           # Steckdosen-Button, Tippen = umschalten
notify_entity: automation.washing_finished         # Benachrichtigungs-Button, Tippen = umschalten
power_entity: sensor.washing_machine_power         # Anzeige + Laufterkennung
power_threshold: 10                                # darüber gilt die Maschine als laufend
power_max: 2500                                    # Maximum der Anzeige
last_wash_entity: input_datetime.wm_last_start     # Startzeitpunkt des Durchgangs
duration_entity: input_number.wm_last_duration     # Dauer des Durchgangs, Minuten
energy_entity: input_number.wm_last_energy         # kWh pro Durchgang
cost_entity: input_number.wm_last_cost             # Kosten pro Durchgang
currency: "€"
language: de                                       # de / en / ru (Standard: HA-Sprache)
```

| Option | Erforderlich | Standard | Beschreibung |
|---|---|---|---|
| `status_entity` | **ja** | — | Entity, deren Zustand einen laufenden Durchgang kennzeichnet. Ein Template-`binary_sensor` auf Leistung oder Strom der Steckdose eignet sich bestens; Text-Zustände (`washing`, `schleudern`, …) werden über `running_states` erkannt. |
| `name` | nein | lokalisiert | Titel der Karte. |
| `plug_entity` | nein | — | Schalter der smarten Steckdose; erscheint als Button in der Kopfzeile, Tippen schaltet um. |
| `notify_entity` | nein | — | Automatisierung / switch / input_boolean für die „Durchgang beendet“-Benachrichtigung; Tippen schaltet um. |
| `power_entity` | nein | — | Leistungs- (W) oder Stromsensor (A): rote Anzeige, Wertanzeige und zweite Laufterkennung. |
| `power_threshold` | nein | `10` | Oberhalb dieses Werts gilt die Maschine als laufend. |
| `power_max` | nein | `2500` | Maximum der Anzeige, in Einheiten von `power_entity`. |
| `last_wash_entity` | nein | — | `input_datetime` mit dem Start des Durchgangs; daraus wird auch die verstrichene Zeit berechnet. |
| `duration_entity` | nein | — | Dauer des letzten Durchgangs in Minuten. |
| `energy_entity` | nein | — | Energie pro Durchgang, kWh. |
| `cost_entity` | nein | — | Kosten pro Durchgang. |
| `currency` | nein | `€` | Währungssymbol für die Kostenspalte. |
| `running_states` | nein | on, washing, waschen, run, schleudern, … | Zustände von `status_entity`, die als „laufend“ gelten. |
| `language` | nein | HA-Sprache | `de`, `en` oder `ru`. |

## 🧠 So funktioniert es mit einer gewöhnlichen Maschine

Die Maschine selbst meldet nichts — alles wird aus einer smarten Steckdose mit Leistungsmessung abgeleitet:

- ein Template-`binary_sensor` (Leistung über einem Schwellwert, mit `delay_off` von einigen Minuten, damit Pausen innerhalb des Durchgangs nicht als „beendet“ zählen) liefert den Status;
- eine kleine Automatisierung speichert den Start des Durchgangs in `input_datetime` und schreibt am Ende Dauer, Verbrauch und Kosten in `input_number`-Helfer, die die Karte im Bereich „Letzter Durchgang“ anzeigt.

Ein fertiges Home-Assistant-Package mit diesen Sensoren, Helfern und Automatisierungen liegt in [`examples/washing_machine_package.yaml`](examples/washing_machine_package.yaml).

## 🔌 Verwendung mit einer smarten Maschine

Wenn deine Wasch- oder Trocknermaschine ihren Zustand bereits selbst meldet, brauchst
du weder die Steckdose noch die Helfer. Home Connect (Bosch / Siemens / Neff /
Gaggenau), Miele@home, LG ThinQ und SmartHQ stellen eine Entity für den
Betriebszustand bereit, sodass `status_entity` direkt darauf zeigen kann:

```yaml
type: custom:washing-machine-card
name: Waschmaschine
status_entity: sensor.washer_operation_state
plug_entity: switch.washer_power
running_states: [run]
```

Für einen Trockner ist die Konfiguration dieselbe, nur mit anderem Präfix. Grenze
`running_states` auf den einen Zustand ein, der wirklich „läuft“ bedeutet, sonst
gilt ein pausiertes oder eingeschaltetes, aber untätiges Gerät als laufend.

[`examples/smart_appliance.yaml`](examples/smart_appliance.yaml) enthält die
ausführliche Variante — inklusive Fortschritt, Endzeit und Türzustand, für die die
Karte keine eigenen Optionen hat, sowie Hinweise dazu, welche Bereiche leer bleiben
und warum.

## 📄 Lizenz

[MIT](LICENSE) © 2026 [sionetta](https://github.com/sionetta)
