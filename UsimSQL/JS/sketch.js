let usim_log;
let usim_struct;
let usim_font;
let usim_ticks;
let usim_current_tick;
let usim_info;
let usim_clr_neutral;
let usim_clr_negative;
let usim_clr_positive;
let usim_clr_link;
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
let usim_sensivity;
let usim_btn_debug;
let usim_btn_debug_label;
let usim_show_debug;
let usim_pg;

function preload() {
  usim_font = loadFont('Inconsolata.otf');
  usim_log = loadJSON('usim_space_log.json');
  usim_struct = loadJSON('usim_space_struct.json');
}

function usimSetup() {
  usim_ticks = usim_log.planck_ticks.length;
  usim_current_tick = 0;
  // animation tick start, dividing one planck tick into 10 slices
  usim_move_tick = 1;
  // color definitions
  usim_clr_neutral = color('aqua');
  usim_clr_negative = color('red');
  usim_clr_positive = color('lime');
  usim_clr_link = color('white');
  // translator for display distance between two points
  usim_magnifier = 100;
  // normalization for energy output displays
  usim_norm_magnifier = 50;
  // default run state -1 = stopped, 1 = running
  usim_run_state = 1;
  usim_btn_run_label = 'Stop';
  // default show state -1 = structure, 1 = process log
  usim_show_state = 1;
  usim_btn_show_label = 'Switch to structure'
  // defines the quadratic frame for simulation displays, offset for GUI elements
  usim_frame_size = 960;
  // defines the real width used for display simulation and GUI elements
  usim_win_width  = 960;
  // frame count per second
  usim_frames = 6;
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
    usim_info = 'aeon: ' + usim_log.planck_aeon + ' tick: ' + usim_log.planck_ticks[usim_current_tick].planck_time + ' move: ' + usim_move_tick;
  } else {
    usim_info = 'mlv id: ' + usim_struct.universe_id;
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
  usim_btn_zero_struct = createButton(usim_btn_zero_label);
  usim_btn_zero_struct.position(usim_frame_size + 10, 100);
  usim_btn_zero_struct.mousePressed(usimChgZeroDisplay);
  usim_btn_debug = createButton(usim_btn_debug_label);
  usim_btn_debug.position(usim_frame_size + 10, 130);
  usim_btn_debug.mousePressed(usimChgDebug);
  usim_sli_frames_label = createP('Frames: ' + usim_frames);
  usim_sli_frames_label.style('color', 'white');
  usim_sli_frames_label.position(usim_frame_size + 10, 140);
  usim_sli_frames = createSlider(1, 60, usim_frames);
  usim_sli_frames.position(usim_frame_size + 10, 180);
  usim_txt_info = createP('aeon:');
  usim_txt_info.style('color', 'white');
  usim_txt_info.position(usim_frame_size + 10, 200);
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
    stroke(usim_clr_neutral);
  } else if (usim_dim_sign == 1) {
    stroke(usim_clr_positive);
  } else {
    stroke(usim_clr_negative);
  }
}

function usimXYZ(usim_vector) {
  return ('' + usim_vector.x + ',' + usim_vector.y + ',' + usim_vector.z);
}

function usimEnergySphere(usim_output) {
  // normalize and get smaller by every move tick
  let r_norm = norm(usim_output, 0, usim_log.max_number) * usim_norm_magnifier / usim_move_tick;
  // upper/lower bounds
  if (r_norm < 2) {
    r_norm = 2;
  } else if (r_norm > usim_norm_magnifier) {
    r_norm = usim_norm_magnifier;
  }
  sphere(r_norm);
}

function usimNodeConnect(usim_from, usim_to) {
  push();
  // if we have a distance
  if (! usim_from.equals(usim_to)) {
    // draw a line
    stroke(usim_clr_link);
    line(usim_from.x, usim_from.y, usim_from.z, usim_to.x, usim_to.y, usim_to.z);
  } else {
    // static lines in dimension 1
    stroke(usim_clr_link);
    line(0, 0, 0, usim_magnifier, 0, 0);
    line(0, 0, 0, -usim_magnifier, 0, 0);
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
    let r_norm = norm(usim_output, 0, usim_log.max_number) * usim_move_tick;
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

function usimDimToPos(n_dim, n_sign, n1_sign){
  // includes displacement
  let usim_xyz = createVector(0, 0, 0);
  let displace = n_sign * (usim_magnifier/2);
  let displaceBase = n1_sign * (usim_magnifier/2)
  if (n_dim == 1) {
    usim_xyz.x = displace;
  } else if (n_dim == 2) {
    usim_xyz.x = displaceBase;
    usim_xyz.y = displace;
  } else if (n_dim == 3) {
    usim_xyz.x = displaceBase;
    usim_xyz.z = displace;
  }
  return usim_xyz.copy();
}

function usimDimStr(n_dim, n_sign, n1_sign) {
  let dimstr = (n1_sign > 0) ? '+n' : '-n';
  if (n_dim == 0) {
    return 'n0';
  } else {
    return dimstr + (n_dim * n_sign);
  }
}

function usimZeroStructure() {
  let usim_details = usim_struct.zero_nodes;
  for (var i = 0; i < usim_details.length; i++) {
    let usim_parent = usim_details[i];
    let usim_base = usimDimToPos(usim_parent.dimension, usim_parent.dim_sign, usim_parent.dim_n1_sign);
    usimDrawPoint(usim_base, usim_parent.dim_n1_sign);
    if (usim_parent.dimension > 0) {
      usimDrawPoint(usim_base, usim_parent.dim_n1_sign);
      let usim_base_to = usim_base.copy();
      if (usim_parent.dimension == 1) {
        usim_base_to.x = usim_parent.dim_sign * (usim_magnifier + usim_magnifier/2);
      } else if (usim_parent.dimension == 2) {
        usim_base_to.y = usim_parent.dim_sign * (usim_magnifier + usim_magnifier/2);
      } else if (usim_parent.dimension == 3) {
        usim_base_to.z = usim_parent.dim_sign * (usim_magnifier + usim_magnifier/2);
      }
      usimNodeConnect(usim_base, usim_base_to);
      usimDrawPoint(usim_base_to, usim_parent.dim_n1_sign, usimDimStr(usim_parent.dimension, usim_parent.dim_sign, usim_parent.dim_n1_sign));
    } else {
      usimDrawPoint(usim_base, usim_parent.dim_n1_sign, usimDimStr(usim_parent.dimension, usim_parent.dim_sign, usim_parent.dim_n1_sign));
    }
  }
}

function usimProcess() {
  let usim_details;
  // redraw structure 0 up to current tick
  for (var ix = 0; ix < usim_current_tick; ix++ ) {
    usim_details = usim_log.planck_ticks[ix].details;
    for (var i = 0; i < usim_details.length; i++) {
      // get output
      let usim_vec_from = createVector(usim_details[i].from.x, usim_details[i].from.y, usim_details[i].from.z);
      let usim_vec_to = createVector(usim_details[i].to.x, usim_details[i].to.y, usim_details[i].to.z);
      // adjust vectors in size
      let usim_xyz_from = usimXYZ(usim_vec_from);
      let usim_xyz_to = usimXYZ(usim_vec_to);
      usim_vec_from.mult(usim_magnifier);
      usim_vec_to.mult(usim_magnifier);
      usimDrawPoint(usim_vec_from, usim_details[i].to.dim_sign, usim_xyz_from);
      usimNodeConnect(usim_vec_from, usim_vec_to);
      usimDrawPoint(usim_vec_to, usim_details[i].to.dim_sign, usim_xyz_to);
    }
  }
  // get details for current tick
  usim_details = usim_log.planck_ticks[usim_current_tick].details;
  for (var i = 0; i < usim_details.length; i++) {
    // get output
    let usim_vec_from = createVector(usim_details[i].from.x, usim_details[i].from.y, usim_details[i].from.z);
    let usim_vec_to = createVector(usim_details[i].to.x, usim_details[i].to.y, usim_details[i].to.z);
    if (usim_move_tick == 1 && usim_show_debug > 0) {
      console.log('' + usim_log.planck_ticks[usim_current_tick].planck_time + ':' + usim_vec_from.x + ',' + usim_vec_from.y + ',' + usim_vec_from.z + ' -> ' + usim_vec_to.x + ',' + usim_vec_to.y + ',' + usim_vec_to.z + '(e=' + usim_details[i].output_energy + ') n' + usim_details[i].from.dimension + '(' + usim_details[i].from.dim_sign + '.' + usim_details[i].from.dim_n1_sign + '):n' + usim_details[i].to.dimension + '(' + usim_details[i].to.dim_sign + '.' + usim_details[i].to.dim_n1_sign + ')');
    }
    // adjust vectors in size
    let usim_xyz_from = usimXYZ(usim_vec_from);
    let usim_xyz_to = usimXYZ(usim_vec_to);
    usim_vec_from.mult(usim_magnifier);
    usim_vec_to.mult(usim_magnifier);
    usimDrawPoint(usim_vec_from, usim_details[i].to.dim_sign, usim_xyz_from);
    usimNodeConnect(usim_vec_from, usim_vec_to);
    usimDrawPoint(usim_vec_to, usim_details[i].to.dim_sign, usim_xyz_to);
    usimColor(usim_details[i].to.dim_sign);
    usimEnergySphere(usim_details[i].output_energy);
    usimMoveEnergy(usim_vec_from, usim_vec_to, usim_details[i].output_energy);
  }
  usimUpdateTicks();
}

function usimStructure() {
  let usim_details = usim_struct.nodes;
  for (var i = 0; i < usim_details.length; i++) {
    let usim_spc = createVector(usim_details[i].xyz[0], usim_details[i].xyz[1], usim_details[i].xyz[2]);
    let usim_xyz = '' + usim_spc.x + ',' + usim_spc.y + ',' + usim_spc.z;
    let usim_clr = 0;
    if (usim_spc.mag() > 0 && usim_spc.heading() >= 0 && usim_spc.heading() != PI) {
      usim_clr = 1;
    }
    if (usim_spc.mag() > 0 && (usim_spc.heading() < 0 || usim_spc.heading() == PI)) {
      usim_clr = -1;
    }
    usim_spc.mult(usim_magnifier);
    usimDrawPoint(usim_spc, usim_clr, usim_xyz);
    let usim_childs = usim_details[i].childs;
    for (var i2 = 0; i2 < usim_childs.length; i2++) {
      let usim_chi = createVector(usim_childs[i2].xyz[0], usim_childs[i2].xyz[1], usim_childs[i2].xyz[2]);
      usim_chi.mult(usim_magnifier);
      usimNodeConnect(usim_spc, usim_chi);
      usimDrawPoint(usim_chi, 1);
  }
  }
}

function draw() {
  // put drawing code here
  usimSensivity();
  orbitControl(usim_sensivity, usim_sensivity);
  usimStartScreen();
  if (usim_show_state > 0) {
    usimProcess();
  } else {
    if (usim_show_zero_struct > 0) {
      usimZeroStructure();
    } else {
      usimStructure();
    }
  }
}
