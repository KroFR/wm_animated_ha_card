# Changelog

All notable changes to this project are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

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
