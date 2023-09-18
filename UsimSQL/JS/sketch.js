let usim_log;
let myfont;
let usim_ticks;
let usim_current_tick;
let usim_info;
let usim_clr_neutral;
let usim_clr_negative;
let usim_clr_positive;
let usim_clr_link;
let usim_move_tick;
let magnifier;
let norm_magnifier;
function preload() {
  myfont = loadFont('Inconsolata.otf');
  usim_log = loadJSON('usim_space_log.json');
}

function setup() {
  // put setup code here
  usim_ticks = usim_log.planck_ticks.length;
  usim_current_tick = 0;
  usim_move_tick = 1;
  usim_clr_neutral = color('aqua');
  usim_clr_negative = color('red');
  usim_clr_positive = color('lime');
  usim_clr_link = color('white');
  magnifier = 100;
  norm_magnifier = 50;
  frameRate(6);
  createCanvas(windowHeight, windowHeight, WEBGL);
  textFont(myfont);
}

function draw() {
  // put drawing code here
  showStartScreen();
  showDetails();
}

function showStartScreen() {
  background(0);
  fill(255);
  textSize(12);
  usim_info = 'aeon: ' + usim_log.planck_aeon + ' tick: ' + usim_log.planck_ticks[usim_current_tick].planck_time;
  text(usim_info, -(windowHeight/2 - 2), (windowHeight/2 - 12));
  stroke(255);
  strokeWeight(1);
  point(0,0,0);
}

function showDetails() {
  // get details for current tick
  let usim_details = usim_log.planck_ticks[usim_current_tick].details;
  for (var i = 0; i < usim_details.length; i++) {
    // get output
    let usim_vec_from = createVector(usim_details[i].from.x, usim_details[i].from.y, usim_details[i].from.z);
    let usim_vec_to = createVector(usim_details[i].to.x, usim_details[i].to.y, usim_details[i].to.z);
    // adjust vectors in size
    usim_vec_from.mult(magnifier);
    usim_vec_to.mult(magnifier);
    nodeConnection(usim_vec_from, usim_vec_to);
    chooseColor(usim_details[i].to.dim_sign);
    energySphere(usim_details[i].output_energy);
    moveEnergy(usim_vec_from, usim_vec_to, usim_details[i].output_energy);
    updateTicks();
  }
}

function chooseColor(usim_dim_sign) {
  if (usim_dim_sign == 0) {
    stroke(usim_clr_neutral);
  } else if (usim_dim_sign == 1) {
    stroke(usim_clr_positive);
  } else {
    stroke(usim_clr_negative);
  }
}

function energySphere(usim_output) {
  // normalize and get smaller by every move tick
  let r_norm = norm(usim_output, 0, usim_log.max_number) * norm_magnifier / usim_move_tick;
  // upper/lower bounds
  if (r_norm < 2) {
    r_norm = 2;
  } else if (r_norm > norm_magnifier) {
    r_norm = norm_magnifier;
  }
  sphere(r_norm);
}

function nodeConnection(usim_from, usim_to) {
  push();
  // if we have a distance
  if (! usim_from.equals(usim_to)) {
    // draw a line
    stroke(usim_clr_link);
    line(usim_from.x, usim_from.y, usim_from.z, usim_to.x, usim_to.y, usim_to.z);
  } else {
    // static lines in dimension 1
    stroke(usim_clr_link);
    line(0, 0, 0, magnifier, 0, 0);
    line(0, 0, 0, -magnifier, 0, 0);
  }
  pop();
}

function moveEnergy(usim_from, usim_to, usim_output) {
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

function updateTicks() {
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