let usim_log;
let usim_struct;
let usim_font;
let usim_ticks;
let usim_current_tick;
let usim_info;
let usim_clr;
let usim_move_tick;
let usim_magnifier;
let usim_norm_magnifier;
let usim_run_state;
let usim_show_state;
let usim_frame_size;
let usim_win_width;
let usim_frames;
let usim_btn_run;
let usim_btn_run_label;
let usim_btn_show;
let usim_btn_show_label;
let usim_txt_info;
let usim_sli_frames;
let usim_sli_frames_label;
let usim_show_coords;
let usim_btn_show_coords;
let usim_btn_show_coords_label;
let usim_btn_zero_struct;
let usim_btn_zero_label;
let usim_show_zero_struct;
let usim_btn_universes;
let usim_btn_universes_label;
let usim_id_universe;
let usim_sensivity;
let usim_btn_debug;
let usim_btn_debug_label;
let usim_show_debug;
let usim_pg;
let usim_current_row;
let usim_stretch_zero;

function preload() {
  usim_font = loadFont('Inconsolata.otf');
  usim_log = loadJSON('usim_space_log.json');
  usim_struct = loadJSON('usim_space_struct.json');
}

function usimSetup() {
  usim_id_universe = 0;
  usim_ticks = usim_log.usims[usim_id_universe].ticks.length;
  usim_current_tick = 0;
  // animation tick start, dividing one planck tick into 10 slices
  usim_move_tick = 1;
  // color definitions
  usim_clr = new Map([
    ["neutral", color('Aqua')],
    ["negative", color('Red')],
    ["positive", color('Lime')],
    ["link_normal", color('White')],
    ["link_background", color('DimGrey')],
    ["point_background", color('Silver')]
  ]);
  // translator for display distance between two points
  usim_magnifier = 100;
  // normalization for energy output displays
  usim_norm_magnifier = 50;
  // default run state -1 = stopped, 1 = running
  usim_run_state = 1;
  usim_btn_run_label = 'Stop';
  // default show state -1 = structure, 1 = process log, 2 = background structure for process (temporary state)
  usim_show_state = 1;
  usim_btn_show_label = 'Switch to structure'
  // defines the quadratic frame for simulation displays, offset for GUI elements
  usim_frame_size = 960;
  // defines the real width used for display simulation and GUI elements
  usim_win_width  = 960;
  // frame count per second
  usim_frames = 24;
  // show coordinates on the simulation or structure, default -1 = off, 1 = on
  usim_show_coords = -1;
  // default label for the show/hide coordinate button
  usim_btn_show_coords_label = 'Display coordinates';
  // default label for zero structure display
  usim_btn_zero_label = 'Switch to zero details';
  // default do not show zero details
  usim_show_zero_struct = -1;
  // default sensivity for orbit control
  usim_sensivity = 100;
  // turn console log on or off, default is off
  usim_show_debug = -1;
  usim_btn_debug_label = 'Debug on';
}

function usimChgRunState() {
  usim_run_state = usim_run_state * -1;
  if (usim_run_state > 0) {
    usim_btn_run_label = 'Stop';
    loop();
  } else {
    usim_btn_run_label = 'Run';
    noLoop();
  }
  usim_btn_run.elt.innerText = usim_btn_run_label;
  usim_btn_run.elt.innerHTML = usim_btn_run_label;
}

function usimChgShowState() {
  usim_show_state = usim_show_state * -1;
  if (usim_show_state > 0) {
    usim_btn_show_label = 'Switch to structure';
  } else {
    usim_btn_show_label = 'Switch to process';
  }
  usim_btn_show.elt.innerText = usim_btn_show_label;
  usim_btn_show.elt.innerHTML = usim_btn_show_label;
}

function usimChgShowCoords() {
  usim_show_coords = usim_show_coords * -1;
  if (usim_show_coords > 0) {
    usim_btn_show_coords_label = 'Hide coordinates';
  } else {
    usim_btn_show_coords_label = 'Show coordinates';
  }
  usim_btn_show_coords.elt.innerText = usim_btn_show_coords_label;
  usim_btn_show_coords.elt.innerHTML = usim_btn_show_coords_label;
}

function usimUpdateText() {
  if (usim_show_state > 0) {
    usim_info = 'aeon: ' + usim_log.aeon + ' tick: ' + usim_log.usims[usim_id_universe].ticks[usim_current_tick].tick + ' move: ' + usim_move_tick;
  } else {
    usim_info = 'Pure structure of selected universe';
  }
  usim_txt_info.elt.innerHTML = usim_info;
  usim_txt_info.elt.innerText = usim_info;
}

function usimUpdateFrames() {
  usim_frames = usim_sli_frames.value();
  // update text
  usim_sli_frames_label.elt.innerHTML = 'Frames: ' + usim_frames;
  usim_sli_frames_label.elt.innerText = 'Frames: ' + usim_frames;
  frameRate(usim_frames);
}

function usimChgZeroDisplay() {
  usim_show_zero_struct = usim_show_zero_struct * -1;
  if (usim_show_zero_struct > 0) {
    usim_btn_zero_label = 'Switch to normal display';
  } else {
    usim_btn_zero_label = 'Switch to zero details';
  }
  usim_btn_zero_struct.elt.innerHTML = usim_btn_zero_label;
  usim_btn_zero_struct.elt.innerText = usim_btn_zero_label;
}

function usimChgDebug() {
  usim_show_debug = usim_show_debug * -1;
  if (usim_show_debug > 0) {
    usim_btn_debug_label = 'Debug off';
  } else {
    usim_btn_debug_label = 'Debug on';
  }
  usim_btn_debug.elt.innerHTML = usim_btn_debug_label;
  usim_btn_debug.elt.innerText = usim_btn_debug_label;
}

function usimChgUniverse() {
  usim_id_universe = usim_btn_universes.value();
}

function usimGUI() {
  usim_btn_run = createButton(usim_btn_run_label);
  usim_btn_run.position(usim_frame_size + 10, 10);
  usim_btn_run.mousePressed(usimChgRunState);
  usim_btn_show = createButton(usim_btn_show_label);
  usim_btn_show.position(usim_frame_size + 10, 40);
  usim_btn_show.mousePressed(usimChgShowState);
  usim_btn_show_coords = createButton(usim_btn_show_coords_label);
  usim_btn_show_coords.position(usim_frame_size + 10, 70);
  usim_btn_show_coords.mousePressed(usimChgShowCoords);
  usim_btn_universes_label = createP('Active universe id');
  usim_btn_universes_label.style('color', 'white');
  usim_btn_universes_label.position(usim_frame_size + 10, 80);
  usim_btn_universes = createSelect();
  usim_btn_universes.position(usim_frame_size + 10, 120)
  for (let index = 0; index < usim_log.select.length; index++) {
    usim_btn_universes.option(usim_log.select[index], index);
  }
  usim_btn_universes.selected(usim_id_universe);
  usim_btn_universes.changed(usimChgUniverse);
  usim_btn_zero_struct = createButton(usim_btn_zero_label);
  usim_btn_zero_struct.position(usim_frame_size + 10, 150);
  usim_btn_zero_struct.mousePressed(usimChgZeroDisplay);
  usim_btn_debug = createButton(usim_btn_debug_label);
  usim_btn_debug.position(usim_frame_size + 10, 180);
  usim_btn_debug.mousePressed(usimChgDebug);
  usim_sli_frames_label = createP('Frames: ' + usim_frames);
  usim_sli_frames_label.style('color', 'white');
  usim_sli_frames_label.position(usim_frame_size + 10, 200);
  usim_sli_frames = createSlider(1, 60, usim_frames);
  usim_sli_frames.position(usim_frame_size + 10, 240);
  usim_txt_info = createP('aeon:');
  usim_txt_info.style('color', 'white');
  usim_txt_info.position(usim_frame_size + 10, 250);
}

function usimSensivity() {
  // calculate sensivity of orbit control by frame rate
  if (usim_frames <= 20) {
    usim_sensivity = map(usim_frames, 5, 20, 100, 10);
  } else {
    usim_sensivity = map(usim_frames, 20, 60, 10, 5);
  }
}

function setup() {
  // put setup code here
  usimSetup();
  frameRate(usim_frames);
  createCanvas(usim_frame_size, usim_win_width, WEBGL);
  textFont(usim_font);
  usim_pg = createGraphics(200, 100);
  usim_pg.textSize(80);
  // set draw center to center of frame only x,y
  translate(usim_frame_size/2, usim_frame_size/2);
  usimGUI();
}

function usimStartScreen() {
  background(0);
  usimUpdateText();
  usimUpdateFrames();
  stroke(255);
  strokeWeight(1);
  point(0,0,0);
}

function usimColor(usim_dim_sign) {
    if (usim_dim_sign == 0) {
      stroke(usim_clr.get("neutral"));
    } else if (usim_dim_sign == 1) {
      stroke(usim_clr.get("positive"));
    } else if (usim_dim_sign == -1) {
      stroke(usim_clr.get("negative"));
    } else if (usim_dim_sign == 2) {
      stroke(usim_clr.get("point_background"));
    }
}

function usimXYZ(usim_vector) {
  return ('' + usim_vector.x + ',' + usim_vector.y + ',' + usim_vector.z);
}

function usimEnergySphere(usim_output) {
  // normalize and get smaller by every move tick
  let r_norm = norm(usim_output, 0, usim_log.max) * usim_norm_magnifier / usim_move_tick;
  // upper/lower bounds
  if (r_norm < 2) {
    r_norm = 2;
  } else if (r_norm > usim_norm_magnifier) {
    r_norm = usim_norm_magnifier;
  }
  sphere(r_norm);
}

function usimNodeConnect(usim_from, usim_to, showMode) {
  push();
  // if we have a distance
  if (! usim_from.equals(usim_to)) {
    // draw a line
    if (showMode != 2) {
      stroke(usim_clr.get("link_normal"));
    } else {
      stroke(usim_clr.get("link_background"));
    }
    line(usim_from.x, usim_from.y, usim_from.z, usim_to.x, usim_to.y, usim_to.z);
  }
  pop();
}

function usimMoveEnergy(usim_from, usim_to, usim_output) {
  // if we have a distance
  if (usim_from.dist(usim_to) != 0) {
    // move energy sphere to target
    push();
    let new_pos = p5.Vector.lerp(usim_from, usim_to, (usim_move_tick / 10));
    translate(new_pos);
    let r_norm = norm(Math.abs(usim_output), 0, usim_log.max) * usim_move_tick;
    // upper/lower bounds
    if (r_norm < 2) {
      r_norm = 2;
    } else if (r_norm > 10) {
      r_norm = 10;
    }
    sphere(r_norm);
    pop();
  }
}

function usimUpdateTicks() {
  if (usim_move_tick < 10) {
    usim_move_tick += 1;
  } else {
    usim_move_tick = 1;
    // get next planck tick
    if (usim_current_tick < (usim_ticks - 1)) {
      usim_current_tick += 1;
    } else {
      // start from beginning
      usim_current_tick = 0;
    }
  }
}

function usimDrawPoint(usim_spc_node, usim_clr_code, usim_txt_xyz) {
  push();
    usimColor(usim_clr_code);
    strokeWeight(1);
    point(usim_spc_node);
    if (usim_show_coords > 0) {
      push()
      translate(usim_spc_node.x + 20, usim_spc_node.y -20, usim_spc_node.z);
      //text(usim_txt_xyz, usim_spc_node.x + 10 - usim_spc_node.z, usim_spc_node.y - 10 + usim_spc_node.z);
      usim_pg.background(0);
      usim_pg.stroke('white');
      usim_pg.fill('white');
      usim_pg.text(usim_txt_xyz, 1, 80);
      //pass image as texture
      texture(usim_pg);
      noStroke();
      plane(20, 10);
      pop();
    }
  pop();
}

function usimDrawRow(rowData, showMode) {
  let usim_vec_from = createVector(rowData.row[0], rowData.row[1], rowData.row[2]);
  let usim_vec_to = createVector(rowData.row[7], rowData.row[8], rowData.row[9]);
  let usim_xyz_from = usimXYZ(usim_vec_from);
  let usim_xyz_to = usimXYZ(usim_vec_to);
  usim_vec_from.mult(usim_magnifier);
  usim_vec_to.mult(usim_magnifier);
  if (usim_show_zero_struct > 0) {
    // n1 sign check
    if (rowData.row[5] > 0) {
      usim_vec_from.x = usim_vec_from.x + usim_magnifier
    } else {
      usim_vec_from.x = usim_vec_from.x - usim_magnifier
    }
    if (rowData.row[12] > 0) {
      usim_vec_to.x = usim_vec_to.x + usim_magnifier
    } else {
      usim_vec_to.x = usim_vec_to.x - usim_magnifier
    }
  }
  let usim_tick = usim_log.usims[usim_id_universe].ticks[usim_current_tick].tick;
  if (showMode == 0) {
    // normal row
    usimDrawPoint(usim_vec_from, rowData.row[11], usim_xyz_from);
    usimNodeConnect(usim_vec_from, usim_vec_to, showMode);
    usimDrawPoint(usim_vec_to, rowData.row[11], usim_xyz_to);
    usimColor(rowData.row[11]);
    usimEnergySphere(rowData.row[14]);
    usimMoveEnergy(usim_vec_from, usim_vec_to, rowData.row[14]);
  } else if (showMode == 1) {
    // structure row normal display
    usimDrawPoint(usim_vec_from, rowData.row[11], usim_xyz_from);
    usimNodeConnect(usim_vec_from, usim_vec_to, showMode);
    usimDrawPoint(usim_vec_to, rowData.row[11], usim_xyz_to);
  } else if (showMode == 2) {
    // structure row display before noral row
    if (rowData.row[6] >= 0 && rowData.row[6] <= usim_tick) {
      // show active
      usimDrawPoint(usim_vec_from, rowData.row[11], usim_xyz_from);
    } else {
      // show inactive
      usimDrawPoint(usim_vec_from, 2, usim_xyz_from);
    }
    if (rowData.row[6] >= 0 && rowData.row[13] >= 0 && rowData.row[6] <= usim_tick && rowData.row[13] <= usim_tick) {
      // show active
      usimNodeConnect(usim_vec_from, usim_vec_to, 1);
    } else {
      // show inactive
      usimNodeConnect(usim_vec_from, usim_vec_to, showMode);
    }
    if (rowData.row[13] >= 0 && rowData.row[13] <= usim_tick) {
      // show active
      usimDrawPoint(usim_vec_to, rowData.row[11], usim_xyz_to);
    } else {
      // show inactive
      usimDrawPoint(usim_vec_to, 2, usim_xyz_to);
    }
  }
}

function usimStructure(showMode) {
  let usim_structure;
  if (usim_show_zero_struct > 0) {
    usim_structure = usim_struct.usims[usim_id_universe].zero;
  } else {
    usim_structure = usim_struct.usims[usim_id_universe].data;
  }
  for (var i = 0; i < usim_structure.length; i++) {
    usimDrawRow(usim_structure[i], showMode);
  }
}

function usimProcess() {
  // redraw structure
  usimStructure(2);
  // get details for current tick
  for (var i = 0; i < usim_log.usims[usim_id_universe].ticks[usim_current_tick].data.length; i++) {
    usimDrawRow(usim_log.usims[usim_id_universe].ticks[usim_current_tick].data[i], 0);
  }
  usimUpdateTicks();
}

function draw() {
  // put drawing code here
  usimSensivity();
  orbitControl(usim_sensivity, usim_sensivity);
  usimStartScreen();
  if (usim_show_state > 0) {
    usimProcess();
  } else {
    usimStructure(1);
  }
}
