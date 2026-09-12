# Changelog

All notable changes to this project are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.3.0] — 2026-09-12

### Added
- **Native Home Assistant theme** — the new `theme: ha` drops the card's own
  palette and paints it with the colours of whichever Home Assistant theme is
  active, so the card blends into a custom theme instead of sitting on top of
  it. `auto`, `light` and `dark` keep the card's own look as before.
  Thanks to [@KroFR](https://github.com/KroFR) (#17).
- **`duration_format`** — with `hhmm`, a last-cycle duration of 60 minutes or
  more is shown as `1h05` instead of `65 min`. Defaults to `minutes`, so
  existing dashboards are unchanged.
  Thanks to [@KroFR](https://github.com/KroFR) (#17).
- **`confirm_plug_off`** — a confirmation prompt before the plug button turns
  the socket **off**, so a mistap can no longer cut a running cycle. Turning the
  plug on is never gated. Defaults to `true`; set it to `false` for the old
  behaviour. Thanks to [@KroFR](https://github.com/KroFR) (#17).
- **Three appliance states instead of two.** When a `power_entity` is
  configured the card now distinguishes *off* (below 1 W), *idle* (above 1 W but
  below `power_threshold`) and *running*. Without a power sensor it stays on
  *idle*, because there is no way to tell an unplugged appliance from a waiting
  one. Thanks to [@KroFR](https://github.com/KroFR) (#17).
- **Visual editor improvements** — a live preview while you configure the card,
  a card name that follows the selected appliance type, and a link to the
  documentation. Thanks to [@KroFR](https://github.com/KroFR) (#17).
- **The installation instructions now cover the entities, not just the card.**
  Installation is split into step 1 (the card file and the dashboard resource)
  and step 2 (the entities), with a walkthrough of the example package for an
  appliance on a smart plug and a table of what it creates. This also documents
  `input_number.el_tarif`, which no README had ever mentioned: it defaults to
  zero, so the cost column silently stayed at `0.00` for anyone who copied the
  package without setting a tariff.

### Changed
- **Dates and times now follow Home Assistant.** The card previously formatted
  them with a locale hardcoded per UI language (`en-GB`, `ru-RU`, …) and never
  looked at your Home Assistant settings. It now takes the locale from
  `hass.locale.language` and honours `hass.locale.time_format`, so a 12/24-hour
  preference is finally respected and a profile set to a regional variant gets
  that region's format — `en-GB` shows `5 Sept, 09:55`, `pt-BR` shows
  `5 de set., 09:55`. Note for English users: a profile set to plain `en` with
  the default time format now shows `Sep 5, 09:55 AM`, matching the rest of the
  Home Assistant interface. Set the Home Assistant time format to 24 hours to
  get `09:55` back. Thanks to [@KroFR](https://github.com/KroFR) (#17).
- **`language: auto`** is now an explicit value rather than an implicit default,
  and is what the visual editor selects for a new card.

### Fixed
- **An appliance with no `power_entity` reported "Off".** The new three-state
  logic defaulted to *off* whenever it could not read power, which is
  misleading: without a power sensor the card cannot tell an unplugged
  appliance from an idle one. It now falls back to *idle*.
  Found in review, fixed by [@KroFR](https://github.com/KroFR) (#17).
- **English showed 12-hour time regardless of the Home Assistant setting.**
  The time format was inferred from the UI language instead of being read from
  `hass.locale.time_format`. Found in review, fixed by
  [@KroFR](https://github.com/KroFR) (#17).

## [1.2.1] — 2026-09-02

### Fixed
- **Cycle duration was displayed incorrectly when it ended in a zero** — a
  30-minute cycle showed as `3 min`, 60 as `6 min`, 100 as `1 min`, and a zero
  duration rendered as an empty string. The trailing-zero trimming in
  `_fmtNum()` used an optional decimal point, so on whole numbers it stripped
  the number's own zeros. Trimming now runs only when there is a fractional
  part, leaving energy and cost formatting untouched.
  Reported and fixed by [@KroFR](https://github.com/KroFR) (#9, #16).

### Added
- **`hide_status_panel`** — when `true`, the status panel (elapsed-time ring and
  power gauge) is hidden while the appliance is idle and reappears as soon as a
  cycle starts. Useful for keeping idle appliances compact on a dashboard.
  Documented in all four languages. Thanks to
  [@KroFR](https://github.com/KroFR) (#16).

### Changed
- **Visual editor reorganized** — the flat fourteen-field form is now grouped
  into collapsible sections (Appliance, Power monitoring, Controls &
  notifications, Last cycle, Appearance), and the language and theme selectors
  show readable labels ("English", "Русский", "Auto (follow Home Assistant)")
  instead of raw codes. Thanks to [@KroFR](https://github.com/KroFR) (#16).

## [1.2.0] — 2026-08-24

### Added
- **Five appliance types** in one card via `appliance_type`: `washer`, `dryer`
  (alias `tumbler`), `dishwasher`, `oven` and `microwave` — each with its own
  SVG illustration, header icon, running animation and localized labels.
  Thanks to [@cr0co](https://github.com/cr0co) (#8).
- **Light and dark themes.** The card follows the Home Assistant theme
  automatically; `theme: auto | light | dark` pins it if you prefer.
- **Visual editor support** — `getConfigForm()` and `getStubConfig()`, so the
  card can be configured from the UI without writing YAML. Thanks to
  [@cr0co](https://github.com/cr0co) (#8).
- **French translation** of the interface. Thanks to
  [@tonyontheroad](https://github.com/tonyontheroad) (#3).
- `README_FR.md`, plus a demo GIF and a light/dark screenshot for every one of
  the four languages.

### Fixed
- SVG gradient IDs are now unique per card instance — two cards on the same
  dashboard no longer share (and corrupt) each other's gradients.
- Language detection matches the full tag first (`pt-br`), then the base
  language (`pt`), so adding a translation needs nothing but a new entry in
  `STRINGS`.

### Changed
- The project is now an **appliance** card rather than a washing-machine card:
  READMEs in all four languages were rewritten accordingly.
- Documentation for smart appliances that report their own state (Home Connect,
  Miele@home, LG ThinQ, SmartHQ) — see `examples/smart_appliance.yaml`.

## [1.1.0] — 2026-08-23

### Added
- **German translation** of the interface and `README_DE.md`. Thanks to
  [@its-me-prash](https://github.com/its-me-prash) (#1, #2).
- Language switcher in every README.

## [1.0.0] — 2026-08-22

First public release: an Oikos-style animated washing machine card for a dumb
machine on a smart plug — animated drum, live status with an elapsed-time ring,
power gauge, last-cycle stats (start / duration / energy / cost), English and
Russian interface, HACS support, MIT license.
