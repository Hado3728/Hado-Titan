// =====================================================================
// 15kg Robowar Bot — Parametric Concept CAD
// Drum spinner + full wedge shell + front & rear forks (invertible)
// =====================================================================
// This is a STARTING PARAMETRIC MODEL for layout/dimension checking —
// not a manufacturing-ready file. Refine in Fusion 360 / SolidWorks /
// Onshape once you finalize real component dimensions from your BOM.
// Edit the variables below and re-render to iterate quickly.
// Competition envelope check: must fit 750 x 750 x 1000 mm at match start.
// =====================================================================

$fn = 64; // smoothness of curved surfaces

// ---------------- CHASSIS ----------------
chassis_length   = 400;  // mm, front-to-back
chassis_width    = 340;  // mm, side-to-side
chassis_height   = 130;  // mm, body height (excludes wheels below deck)
wedge_taper      = 90;   // mm, how far back the front wedge taper runs
shell_thickness  = 4;    // mm, shell wall thickness (visual only here)

// ---------------- DRUM WEAPON ----------------
drum_diameter    = 110;  // mm
drum_length      = 200;  // mm, spans most of the chassis width
drum_offset_x    = chassis_length/2 - 20; // drum sits near the front
drum_offset_z    = chassis_height/2 + 10; // drum axis height

// ---------------- WHEELS ----------------
wheel_diameter   = 130;  // mm
wheel_width      = 45;   // mm
wheel_offset_x   = 40;   // mm behind center, fore-aft position
wheel_offset_z   = -chassis_height/2 + 10; // wheels drop below chassis belly

// ---------------- FORKS ----------------
fork_length      = 110;  // mm, how far forks extend beyond the shell
fork_width       = 60;   // mm, width of each fork blade
fork_thickness   = 8;    // mm
fork_count       = 5;    // number of fork tines per end
fork_gap         = 8;    // mm gap between tines

// =====================================================================
// MODULES
// =====================================================================

module wedge_shell() {
    // Body: a box with the front third tapered into a wedge via hull()
    hull() {
        // Rear block (full height)
        translate([-chassis_length/2 + wedge_taper, 0, 0])
            cube([chassis_length - wedge_taper, chassis_width, chassis_height], center = true);
        // Front wedge edge (low, thin leading edge)
        translate([chassis_length/2 - 2, 0, -chassis_height/2 + 4])
            cube([4, chassis_width - 20, 8], center = true);
    }
}

module drum_weapon() {
    color("OrangeRed")
    rotate([0, 90, 0])
        translate([0, 0, drum_offset_x])
            cylinder(h = drum_length, d = drum_diameter, center = true);
}

module drum_cutout_shroud() {
    // Simple containment shroud: a partial cylinder cavity around the drum,
    // open only at the front-facing arc.
    color("DimGray", 0.5)
    rotate([0, 90, 0])
        translate([0, 0, drum_offset_x])
            cylinder(h = drum_length + 4, d = drum_diameter + 16, center = true);
}

module wheel(mirror_y = 1) {
    color("Black")
    translate([wheel_offset_x, mirror_y * (chassis_width/2 - wheel_width/2 + 6), wheel_offset_z])
        rotate([90, 0, 0])
            cylinder(h = wheel_width, d = wheel_diameter, center = true);
}

module fork_set(x_pos, point_dir = 1) {
    // A row of angled tines forming a fork/spike rake at one end of the bot
    color("SlateGray")
    for (i = [0 : fork_count - 1]) {
        y = -chassis_width/2 + 10 + i * (fork_width + fork_gap);
        translate([x_pos, y, -chassis_height/2 + fork_thickness/2])
            hull() {
                cube([2, fork_width, fork_thickness], center = true);
                translate([point_dir * fork_length, fork_width/2 - fork_width/2, 0])
                    cube([2, fork_width * 0.4, fork_thickness * 0.5], center = true);
            }
    }
}

// =====================================================================
// ASSEMBLY
// =====================================================================

module robot_assembly() {
    difference() {
        color("Gainsboro", 0.85) wedge_shell();
        drum_cutout_shroud();
    }
    drum_weapon();
    wheel(1);
    wheel(-1);
    fork_set(chassis_length/2, 1);   // front forks
    fork_set(-chassis_length/2, -1); // rear forks
}

robot_assembly();

// =====================================================================
// Quick footprint check against the 750 x 750 x 1000 mm rule envelope
// (printed to console when rendered from the OpenSCAD GUI / CLI)
// =====================================================================
echo("Chassis length (mm): ", chassis_length + fork_length*2);
echo("Chassis width (mm): ", chassis_width);
echo("Chassis height (mm): ", chassis_height);
echo("Rule limit (mm): 750 x 750 x 1000 - check these stay under that.");
