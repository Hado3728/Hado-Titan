# Hado Titan — 15kg Robowar Combat Robot

A drum-spinner combat robot built for 15kg-category robowar competition
![Assembled concept render (THIS IS THE INSPIRATION MODEL "NITRO")](docs/images/preview_assembled_v2.png)

## Overview

Hado Titan is a fixed-unibody wedge chassis with a belt-driven weapon drum and full-height wheels for invertible driving. Design is inspired by [Nitro](https://forum.bristolbotbuilders.com/t/nitro-13-6kg-fc-drum-spinner/177), a well-documented 13.6kg FC drum spinner from the Bristol Bot Builders community — component classes and construction lessons are adapted from that build, not copied wholesale.

**Category:** 15kg Robowar
**Weapon type:** Belt-driven drum spinner, toggled on/off during matches (not continuous)
**Drive:** Two full-height wheels, reversible ESC for topple recovery
**Status:** Component sourcing + CAD in progress

## Why a drum spinner

The fixed front/rear wedges corner opponents for control while the drum — toggled on/off rather than run continuously — punishes any contact, whether or not the corner attempt succeeds. This gives the bot an active-defense element even when it isn't fully controlling an engagement.

## Sketches

| Document | Contents |
|---|---|
| [`docs/images/Side armour sketch.png`](docs/images/Side armour sketch.png) | SKETCH OF THE SIDE VIEW OF THE OUTER SHELL |
## CAD

- `cad/ARMOUR FINAL.SLDPRT` — 3D Model of the outer armour shell (UNIBODY)
- `cad/CASE.SLDPRT` — 3D Design of the electronics casing
- `cad/Spinning drum FINAL.SLDPRT` — 3D Model of the Spinning Weapon Drum
- 'cad/ATTACHMENT LATCHES' - 3D Model of the metal supporting attachments for the CASE and the main CHASSIS 
Also includes various models of the electronics for reference purposes and split parts

## Bill of Materials

See [`bom/BOM_hado_titan_v2.xlsx`](bom/BOM_hado_titan_v2.xlsx) for the current priced + weighed component list 

**Sourcing:** Robu.in (batteries, receiver, wheels, bearings, fasteners) + Zerodrag (weapon/drive motors, reversible ESC) — both India-based to avoid import customs delays on the funding timeline.

## Electronics

- **Weapon + drive ESC:** Zerodrag Boost AM32 55A 4-in-1 — single board, AM32 firmware's 3D/reverse mode drives both the weapon channel and both drive motor channels off one battery
- **Weapon motor:** Surpass Hobby Rocket 4092 1250KV
- **Drive motors:** Zerodrag QPT 2807-1300KV (x2)
- **Radio:** FlySky FS-i6X (6CH) + FS-iA10B receiver
- **Battery:** Single 6S LiPo (22.2V), shared across weapon and drive through the 4-in-1 ESC
- A rough circuit of the electronic connection (AI GENERATED IMAGE) 'circuit-diagram.svg'

Reverse capability was a hard requirement — if the bot topples mid-match, drive needs to work upside down without manual intervention. AM32's documented 3D mode handles this natively, unlike several drone-oriented ESCs evaluated that don't support reverse at all.

## Ruleset compliance

- Dimension envelope: 750mm × 750mm × 1000mm (l × b × h) at match start
- Weight limit: 15kg including all batteries, mechanics, and weapons
- Voltage limit: 36V DC/AC max anywhere on the bot — 6S (22.2V nominal) keeps well clear of this
- No pneumatic weapons, so the tank-weight-multiplier rule doesn't apply



## Team

Built by a first-year BTech CSE student from IIIT Pune
## License

MIT — see [LICENSE](LICENSE)
