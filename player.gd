extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2
const WALL_SLIDE_SPEED = 50.0
const WALL_CLIMB_SPEED = -150.0
const JUMP_ANIM_LOCK_TIME = 0.15
const DASH_SPEED = 600.0
const DASH_TIME = 0.2
const MAX_AIR_DASHES = 2

@onready var animated_sprite_2d = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var is_wall_sliding = false
var is_wall_climbing = false
var jump_anim_timer = 0.0
var jump_type = ""

var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0
var air_dashes_left = MAX_AIR_DASHES
var is_ground_dash = false


func _ready():
	if not is_in_group("player"):
		add_to_group("player")


func _physics_process(delta):

	if jump_anim_timer > 0:
		jump_anim_timer -= delta

	if is_on_floor():
		jumps_left = MAX_JUMPS
		air_dashes_left = MAX_AIR_DASHES
		is_wall_climbing = false
		if is_dashing and not is_ground_dash:
			end_dash()
		jump_type = ""

	var horizontal = Input.get_axis("ui_left", "ui_right")
	var vertical_up = Input.is_action_pressed("ui_up")

	# تشغيل الداش
	if Input.is_action_just_pressed("ui_dash") and horizontal != 0:
		if is_on_floor():
			start_dash(horizontal, true)
		elif air_dashes_left > 0:
			start_dash(horizontal, false)

	# منطق الداش
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

		if dash_timer <= 0:
			end_dash()

	else:
		if horizontal != 0:
			velocity.x = horizontal * SPEED
			animated_sprite_2d.flip_h = horizontal < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# wall logic
	is_wall_sliding = not is_on_floor() and is_on_wall() and velocity.y > 0
	is_wall_climbing = not is_on_floor() and is_on_wall() and vertical_up

	if is_wall_climbing:
		velocity.y = WALL_CLIMB_SPEED

	elif is_wall_sliding:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)

	elif not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta

	# jump
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0 and not is_dashing:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
		is_wall_climbing = false
		jump_anim_timer = JUMP_ANIM_LOCK_TIME

		if jumps_left == MAX_JUMPS - 1:
			jump_type = "jump"
		else:
			jump_type = "double_jump"

	# animations
	if is_dashing:
		animated_sprite_2d.play("dash")

	elif jump_anim_timer > 0:
		animated_sprite_2d.play(jump_type)

	else:
		if is_on_floor():
			if abs(velocity.x) > 10:
				animated_sprite_2d.play("run")
			else:
				animated_sprite_2d.play("idle")

		elif is_wall_climbing:
			animated_sprite_2d.play("wall_climb")

		elif is_wall_sliding:
			animated_sprite_2d.play("wall_slide")

		else:
			if velocity.y < 0:
				animated_sprite_2d.play("jump")
			else:
				animated_sprite_2d.play("fall")

	move_and_slide()


func start_dash(direction, ground: bool):
	is_dashing = true
	is_ground_dash = ground
	dash_direction = sign(direction)
	dash_timer = DASH_TIME

	if not ground:
		air_dashes_left -= 1


func end_dash():
	is_dashing = false
	is_ground_dash = false


func bounce():
	velocity.y = JUMP_VELOCITY


func give_dash():
	air_dashes_left = MAX_AIR_DASHES
	print("Player: give_dash() called, air_dashes_left =", air_dashes_left)
