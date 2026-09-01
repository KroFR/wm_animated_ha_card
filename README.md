# 🏠 Animated Appliance Card for Home Assistant

**English** | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md)

An Oikos-inspired Lovelace card that turns a *dumb* washer, dryer, dishwasher, oven or microwave on a smart plug into a beautiful, animated dashboard widget — no smart appliance required.

![Demo](media/demo_en.gif)

<sub>Same card in other UI languages: [Русский](media/demo_ru.gif) · [Deutsch](media/demo_de.gif) · [Français](media/demo_fr.gif)</sub>

## ✨ Features

- **Five appliances, one card** — `washer`, `dryer`, `dishwasher`, `oven` and `microwave`, each with its own illustration, icon and wording. Switch with a single line: `appliance_type: dryer`.
- **Animated while running** — laundry tumbles behind the glass, dishwasher jets sweep, the oven glows, the microwave turntable turns. All animation is pure CSS/SVG, no external assets, and it respects `prefers-reduced-motion`.
- **Light and dark themes** — the card follows your Home Assistant theme automatically, or you can pin it with `theme: light | dark`.
- **Live status** — a pulsing "RUNNING / IDLE" badge, an elapsed-time ring and a power gauge with automatic unit handling (`1950 W` is shown as `1.95 kW`; an ampere sensor is labelled "Current draw" automatically).
- **Last cycle summary** — start time ("Today, 09:55"), duration, energy and cost, each column tappable for more-info.
- **Quick actions** — header buttons toggle the smart plug and the finish-notification automation, and open the power history.
- **Four languages** — English, Russian, German and French labels out of the box. The language follows your Home Assistant profile, or set `language: en | ru | de | fr` explicitly.
- **Visual editor** — the card ships a config form, so it can be set up from the UI without touching YAML.
- **Zero dependencies** — a single vanilla-JS file with Shadow DOM. Every entity option except `status_entity` is optional: blocks without an entity are simply hidden. Responsive via CSS container queries.

## 🌗 Light and dark

![Light and dark theme](media/themes_en.jpg)

`theme: auto` (the default) follows Home Assistant: switch your dashboard to a dark theme and the card follows on the next render. `theme: light` and `theme: dark` pin it regardless of the dashboard.

## 📦 Installation

### Manual

1. Copy [`washing-machine-card.js`](washing-machine-card.js) to `/config/www/`.
2. Add a dashboard resource (Settings → Dashboards → Resources, or `lovelace: resources:` in YAML mode):

   ```yaml
   url: /local/washing-machine-card.js?v=3
   type: module
   ```

   Bump `?v=` after every update to bust the browser cache.

### HACS

Add `https://github.com/sionetta/wm_animated_ha_card` as a **custom repository** (type: Dashboard), then install *Washing Machine Animated Card*.

## ⚙️ Configuration

```yaml
type: custom:washing-machine-card
appliance_type: washer                             # washer | dryer | dishwasher | oven | microwave
name: Washing machine
status_entity: binary_sensor.washing_in_progress   # REQUIRED
plug_entity: switch.washing_machine_plug           # plug button, tap = toggle
notify_entity: automation.washing_finished         # notification button, tap = toggle
power_entity: sensor.washing_machine_power         # gauge + running detection
power_threshold: 10                                # running above this value
power_max: 2500                                    # gauge maximum
last_wash_entity: input_datetime.wm_last_start     # cycle start timestamp
duration_entity: input_number.wm_last_duration     # cycle duration, minutes
energy_entity: input_number.wm_last_energy         # kWh per cycle
cost_entity: input_number.wm_last_cost             # cost per cycle
currency: "€"
language: en                                       # en / ru / de / fr (default: HA language)
theme: auto                                        # auto / light / dark
```

| Option | Required | Default | Description |
|---|---|---|---|
| `appliance_type` | no | `washer` | Visual + labels: `washer`, `dryer` (alias `tumbler`), `dishwasher`, `oven` or `microwave`. |
| `status_entity` | **yes** | — | Entity whose state marks a running cycle. A template `binary_sensor` on the plug's power/current works great; textual states (`washing`, `spin`, …) are matched via `running_states`. |
| `appliance_type` | no | `washer` | Visual + labels: `washer`, `dryer` (alias `tumbler`), `dishwasher`, `oven` or `microwave`. |
| `name` | no | localized | Card title (defaults depend on `appliance_type`). |
| `plug_entity` | no | — | Smart plug switch; shown as a header button, tap toggles it. |
| `notify_entity` | no | — | Automation/switch/input_boolean for the "cycle finished" notification; tap toggles it. |
| `power_entity` | no | — | Power (W) or current (A) sensor: red gauge, value display and a second "running" detector. |
| `power_threshold` | no | `10` | Above this value the appliance counts as running. |
| `power_max` | no | `2500` | Gauge maximum, in `power_entity` units. |
| `last_wash_entity` | no | — | `input_datetime` with the cycle start; also the source of the elapsed time. |
| `duration_entity` | no | — | Last cycle duration in minutes. |
| `energy_entity` | no | — | Energy per cycle, kWh. |
| `cost_entity` | no | — | Cost per cycle. |
| `currency` | no | `€` | Currency symbol for the cost column. |
| `running_states` | no | on, washing, run, spin, rinse, … | States of `status_entity` treated as "running" (English, Russian, German and French states are recognised). |
| `language` | no | HA language | `en`, `ru`, `de` or `fr`. |
| `theme` | no | `auto` | `auto` follows the Home Assistant theme, `light` and `dark` pin it. |

## 🧺 Appliance types

| `appliance_type` | Default title | Running label |
|---|---|---|
| `washer` | Washing machine | Washing |
| `dryer` (alias `tumbler`) | Dryer | Drying |
| `dishwasher` | Dishwasher | Washing dishes |
| `oven` | Oven | Baking |
| `microwave` | Microwave | Heating |

Titles and labels are translated into all four languages; `name` overrides the title.

## 🧠 How it works with a dumb appliance

The appliance itself reports nothing — everything is derived from a smart plug with power monitoring:

- a template `binary_sensor` (power above a threshold, with `delay_off` of a few minutes so inter-cycle pauses don't count as "finished") drives the status;
- a small automation stores the cycle start into `input_datetime`, and on finish writes duration, energy and cost into `input_number` helpers which the card displays as the "Last cycle" panel.

An example Home Assistant package with these sensors, helpers and automations is in [`examples/washing_machine_package.yaml`](examples/washing_machine_package.yaml).

## 🔌 Using it with a smart appliance

If your appliance already reports its own state, you don't need the plug or any of the
helpers. Home Connect (Bosch / Siemens / Neff / Gaggenau), Miele@home, LG ThinQ and
SmartHQ all expose an operation state entity, so `status_entity` can point straight at it:

```yaml
type: custom:washing-machine-card
appliance_type: washer
status_entity: sensor.washer_operation_state
plug_entity: switch.washer_power
running_states: [run]
```

A dryer, dishwasher, oven or microwave is the same config with a different
`appliance_type` and entity prefix. Narrow `running_states` to the one state that
really means "running", otherwise a paused or powered-but-idle appliance reads as running.

[`examples/smart_appliance.yaml`](examples/smart_appliance.yaml) has the full version,
including the progress, finish time and door values the card has no options for, plus
notes on what stays empty and why.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for the release history.

## 📄 License

[MIT](LICENSE) © 2026 [sionetta](https://github.com/sionetta)
