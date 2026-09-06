include <common.scad>

// Exploded view — each part pulled apart along its natural separation axis
// so you can see every individual component that makes up the assembly.

translate([0, 0, -60]) part_base_chassis();

translate([0, 90, 0]) part_side_panel();
translate([0, -90, 0]) mirror([0,1,0]) part_side_panel();

translate([0, 0, 90]) part_top_shell();

translate([60, -40, 0]) part_front_wedge();
translate([60, 40, 0]) mirror([0,1,0]) part_front_wedge();

translate([-60, 0, 0]) part_rear_bumper();

translate([120, 0, 40]) part_drum_weapon();
translate([170, 0, 40]) part_drum_shroud();

translate([40, 0, -70]) part_front_forks();
translate([-40, 0, -70]) part_rear_forks();

translate([0, 140, -30]) part_wheel();
translate([0, -140, -30]) mirror([0,1,0]) part_wheel();

translate([0, 0, 150]) part_top_hardware();
