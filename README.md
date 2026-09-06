# Hado Titan — 15kg Robowar Combat Robot

A drum-spinner combat robot built for 15kg-category robowar competition, funded through [Hack Club's Forge](https://hackclub.com/forge/) program.

![Assembled concept render](docs/images/preview_assembled_v2.png)

## Overview

Hado Titan is a fixed-unibody wedge chassis with a belt-driven weapon drum and full-height wheels for invertible driving. Design is inspired by [Nitro](https://forum.bristolbotbuilders.com/t/nitro-13-6kg-fc-drum-spinner/177), a well-documented 13.6kg FC drum spinner from the Bristol Bot Builders community — component classes and construction lessons are adapted from that build, not copied wholesale.

**Category:** 15kg Robowar
**Weapon type:** Belt-driven drum spinner, toggled on/off during matches (not continuous)
**Drive:** Two full-height wheels, reversible ESC for topple recovery
**Status:** Component sourcing + CAD in progress

## Why a drum spinner

The fixed front/rear wedges corner opponents for control while the drum — toggled on/off rather than run continuously — punishes any contact, whether or not the corner attempt succeeds. This gives the bot an active-defense element even when it isn't fully controlling an engagement.

## Design docs

| Document | Contents |
|---|---|
| [`docs/images/dimensioned_sketch.png`](docs/images/dimensioned_sketch.png) | Top/side/front views with key dimensions and rule-envelope check |
| [`docs/images/preview_assembled.png`](docs/images/preview_assembled.png) | Assembled concept render |
| [`docs/images/preview_exploded.png`](docs/images/preview_exploded.png) | Exploded parts view |

## CAD

Parametric OpenSCAD model — every dimension is a named variable in `cad/common.scad`, so resizing the drum, forks, or wheels updates the whole assembly.

- `cad/common.scad` — shared parameters + part modules
- `cad/assembly.scad` — full assembled render
- `cad/exploded.scad` — exploded view for visualizing individual parts
- `cad/robot_full_assembly.stl` — combined mesh export
- `cad/robowar_parts_stl.zip` — each part (base chassis, side panels, top shell, wedges, drum, shroud, forks, wheels, hardware) as its own STL, positioned to reassemble correctly

> CAD is a layout/dimension-checking model, not manufacturing-ready — no fastener holes, wall thickness tuned for machining, or GD&T. Final surfacing happens in Fusion 360/SolidWorks once components are finalized.

## Bill of Materials

See [`bom/BOM_hado_titan_buffered.xlsx`](bom/BOM_hado_titan_buffered.xlsx) for the current priced + weighed component list (electronics, drivetrain, weapon system — excludes chassis and drum body, which are sized once material/thickness are finalized).

**Sourcing:** Robu.in (batteries, receiver, wheels, bearings, fasteners) + Zerodrag (weapon/drive motors, reversible ESC) — both India-based to avoid import customs delays on the funding timeline.

Also included:
- `bom/15kg_weight_budget.xlsx` — component-only weight tracking against the 15kg limit
- `bom/15kg_dimensioned_BOM.xlsx` — CNC-ready dimensions and bearing specs per part

## Electronics

- **Weapon + drive ESC:** Zerodrag Boost AM32 55A 4-in-1 — single board, AM32 firmware's 3D/reverse mode drives both the weapon channel and both drive motor channels off one battery
- **Weapon motor:** Surpass Hobby Rocket 4092 1250KV
- **Drive motors:** Zerodrag QPT 2807-1300KV (x2)
- **Radio:** FlySky FS-i6X (6CH) + FS-iA10B receiver
- **Battery:** Single 6S LiPo (22.2V), shared across weapon and drive through the 4-in-1 ESC

Reverse capability was a hard requirement — if the bot topples mid-match, drive needs to work upside down without manual intervention. AM32's documented 3D mode handles this natively, unlike several drone-oriented ESCs evaluated that don't support reverse at all.

## Ruleset compliance

- Dimension envelope: 750mm × 750mm × 1000mm (l × b × h) at match start
- Weight limit: 15kg including all batteries, mechanics, and weapons
- Voltage limit: 36V DC/AC max anywhere on the bot — 6S (22.2V nominal) keeps well clear of this
- No pneumatic weapons, so the tank-weight-multiplier rule doesn't apply

## Roadmap

- [ ] Confirm exact prices/weights on remaining estimated BOM lines
- [ ] Finalize drum diameter and weapon shaft size against kinetic energy target
- [ ] Complete manufacturing-ready CAD (Fusion 360/SolidWorks) with fastener holes and material thickness
- [ ] Machine/fabricate chassis (CNC for drum + shaft + motor mounts, sheet metal + bending for shell panels)
- [ ] Assemble and bench-test drivetrain + weapon independently before full integration
- [ ] Weigh-in dry run before competition to confirm under 15kg

## Team

Built by a first-year BTech CSE student in Bengaluru, India — first combat robotics build.

## License

MIT — see [LICENSE](LICENSE)
