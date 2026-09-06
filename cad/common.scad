// =====================================================================
// 15kg Robowar Bot — Multi-Part Assembly (common definitions)
// Each module below is ONE separate, disassemblable part.
// Included by assembly.scad (full preview) and by each individual
// part_*.scad export file (one part exported alone, in its assembled
// position, so all files line up if reassembled together).
// =====================================================================

$fn = 48;

// ---------------- OVERALL FOOTPRINT ----------------
body_length   = 380;   // mm, main chassis body (excludes forks)
body_width    = 320;   // mm
body_height   = 120;   // mm, side panel height
panel_thick   = 8;     // mm, side panel / shell wall thickness

// ---------------- TOP SHELL ----------------
shell_length  = body_length - 10;
shell_width   = body_width - 10;
shell_thick   = 8;
shell_corner_r = 18;

// ---------------- FRONT WEDGE (finned nose, left side of ref image) ----------------
wedge_length  = 90;
wedge_width   = body_width * 0.5;   // covers roughly half the width (one side)
wedge_fins    = 5;
wedge_fin_w   = 6;
wedge_fin_gap = 6;

// ---------------- REAR BUMPER ----------------
rear_length   = 40;

// ---------------- DRUM WEAPON ----------------
drum_dia      = 100;
drum_length   = 150;
drum_fins     = 8;
drum_fin_h    = 6;
drum_x        = body_length/2 - 55;   // drum sits toward the front-right
drum_z        = 0;

// ---------------- DRUM SHROUD (containment housing) ----------------
shroud_dia    = drum_dia + 24;
shroud_open_deg = 170; // arc left open facing forward/down (striking face)

// ---------------- FORKS ----------------
fork_length   = 90;
fork_width    = 46;
fork_thick    = 7;
fork_count    = 5;
fork_gap      = 6;

// ---------------- WHEELS ----------------
wheel_dia     = 140;
wheel_width   = 40;
wheel_x       = -body_length/2 + 90;
wheel_z       = -body_height/2 + 5;

// ---------------- TOP HARDWARE (bolt row) ----------------
bolt_dia      = 12;
bolt_h        = 10;
bolt_count    = 4;

// =====================================================================
// PART 1 — Base chassis (structural floor plate everything mounts to)
// =====================================================================
module part_base_chassis() {
    color("DarkSlateGray")
    translate([0, 0, -body_height/2])
        cube([body_length, body_width, 10], center = true);
}

// =====================================================================
// PART 2 — Side panel (armor wall). mirror_side: 1 = right, -1 = left
// Exported once; use twice (mirrored) when physically assembling.
// =====================================================================
module part_side_panel() {
    color("Gainsboro")
    translate([0, body_width/2 - panel_thick/2, 0])
        hull() {
            translate([-body_length/2 + 40, 0, 0])
                cube([body_length - 80, panel_thick, body_height], center = true);
            translate([body_length/2 - 4, 0, -body_height/2 + 6])
                cube([4, panel_thick, 12], center = true);
        }
}

// =====================================================================
// PART 3 — Top shell (rounded armor deck)
// =====================================================================
module part_top_shell() {
    color("WhiteSmoke")
    translate([0, 0, body_height/2])
        linear_extrude(height = shell_thick)
            offset(r = shell_corner_r)
                square([shell_length - 2*shell_corner_r, shell_width - 2*shell_corner_r], center = true);
}

// =====================================================================
// PART 4 — Front wedge nose (finned, sits on the leading corner)
// =====================================================================
module part_front_wedge() {
    color("Gainsboro")
    translate([body_length/2 - 10, -body_width/4, 0]) {
        difference() {
            hull() {
                cube([2, wedge_width, body_height], center = true);
                translate([wedge_length, 0, -body_height/2 + 6])
                    cube([2, wedge_width * 0.9, 10], center = true);
            }
            // fin slots
            for (i = [0 : wedge_fins - 1]) {
                translate([wedge_length * 0.4, -wedge_width/2 + 10 + i*(wedge_fin_w+wedge_fin_gap), 0])
                    cube([wedge_length, wedge_fin_w, body_height + 2], center = true);
            }
        }
    }
}

// =====================================================================
// PART 5 — Rear bumper (back armor block)
// =====================================================================
module part_rear_bumper() {
    color("Gainsboro")
    translate([-body_length/2 - rear_length/2 + 2, 0, 0])
        cube([rear_length, body_width * 0.9, body_height * 0.9], center = true);
}

// =====================================================================
// PART 6 — Drum weapon (finned spinning cylinder, removable cartridge)
// =====================================================================
module part_drum_weapon() {
    translate([drum_x, 0, drum_z])
        rotate([0, 90, 0]) {
            color("OrangeRed")
            cylinder(h = drum_length, d = drum_dia, center = true);
            color("OrangeRed")
            for (i = [0 : drum_fins - 1]) {
                rotate([0, 0, i * 360 / drum_fins])
                    translate([drum_dia/2, 0, 0])
                        cube([drum_fin_h, 6, drum_length - 4], center = true);
            }
            color("Black")
            translate([0, 0, drum_length/2 - 4])
                cylinder(h = 8, d = drum_dia * 0.5, center = true);
            color("Black")
            translate([0, 0, -drum_length/2 + 4])
                cylinder(h = 8, d = drum_dia * 0.5, center = true);
        }
}

// =====================================================================
// PART 7 — Drum shroud (containment housing, open on the striking arc)
// =====================================================================
module part_drum_shroud() {
    color("DimGray")
    translate([drum_x, 0, drum_z])
        rotate([0, 90, 0])
            difference() {
                cylinder(h = drum_length + 10, d = shroud_dia, center = true);
                cylinder(h = drum_length + 14, d = drum_dia + 4, center = true);
                // open striking arc (faces outward/forward-down)
                rotate([0, 0, 45])
                    translate([shroud_dia*0.9, 0, 0])
                        rotate([0, 0, -shroud_open_deg])
                            cube([shroud_dia*3, shroud_dia*3, drum_length + 20]);
            }
}

// =====================================================================
// PART 8 — Front forks (tine rake, bolts to the front underside)
// =====================================================================
module part_front_forks() {
    color("SlateGray")
    translate([body_length/2, 0, -body_height/2])
        for (i = [0 : fork_count - 1]) {
            translate([0, -body_width/2 + 10 + i*(fork_width+fork_gap), fork_thick/2])
                hull() {
                    cube([2, fork_width, fork_thick], center = true);
                    translate([fork_length, 0, 0])
                        cube([2, fork_width * 0.4, fork_thick * 0.5], center = true);
                }
        }
}

// =====================================================================
// PART 9 — Rear forks (tine rake, bolts to the rear underside)
// =====================================================================
module part_rear_forks() {
    color("SlateGray")
    translate([-body_length/2 - rear_length + 2, 0, -body_height/2])
        for (i = [0 : fork_count - 1]) {
            translate([0, -body_width/2 + 10 + i*(fork_width+fork_gap), fork_thick/2])
                hull() {
                    cube([2, fork_width, fork_thick], center = true);
                    translate([-fork_length*0.7, 0, 0])
                        cube([2, fork_width * 0.4, fork_thick * 0.5], center = true);
                }
        }
}

// =====================================================================
// PART 10 — Wheel (export once, use x2 mirrored in final assembly)
// =====================================================================
module part_wheel() {
    color("Black")
    translate([wheel_x, body_width/2 + wheel_width/2 - panel_thick, wheel_z])
        rotate([90, 0, 0])
            cylinder(h = wheel_width, d = wheel_dia, center = true);
}

// =====================================================================
// PART 11 — Top hardware (bolt row on the deck)
// =====================================================================
module part_top_hardware() {
    color("SteelBlue")
    for (i = [0 : bolt_count - 1]) {
        translate([body_length/2 - 60 - i*40, 0, body_height/2 + shell_thick])
            cylinder(h = bolt_h, d = bolt_dia, center = true);
    }
}

// =====================================================================
// Convenience: every part, for the combined preview only
// (assembly.scad uses this; individual exports call one module each)
// =====================================================================
module full_assembly() {
    part_base_chassis();
    part_side_panel();
    mirror([0,1,0]) part_side_panel();
    part_top_shell();
    part_front_wedge();
    mirror([0,1,0]) part_front_wedge();
    part_rear_bumper();
    part_drum_weapon();
    part_drum_shroud();
    part_front_forks();
    part_rear_forks();
    part_wheel();
    mirror([0,1,0]) part_wheel();
    part_top_hardware();
}
