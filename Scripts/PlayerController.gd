class_name PlayerController
extends CharacterBody3D

@onready var camera : Camera3D = get_node("Camera3D")
@onready var potion_marker : Marker3D = get_node("Camera3D/Marker3D")
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var drag = ProjectSettings.get_setting("physics/3d/default_linear_damp")

@export_group("Ground Movement")
@export var move_speed : float = 5.5
@export var acceleration : float = 20.0
@export var dash_speed : float = 20.0
var is_dashing : bool = false
var can_dash : bool = true
var can_move : bool = true

@export_group("Air Movement")
@export var jump_velocity : float = 5.5
@export var grav_multiplier : float = 1.5

@export_group("Camera Movement")
@export var look_sens : float = 0.002
var camera_look_input : Vector2

@export_group("Throw Mechanic")
@export var show_trajectory : bool = true
@export var throw_strength : float = 10.0
var can_throw : bool = true
var potion_thrown : bool = false
var potion = preload("res://Models/Potion.tscn")

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			camera_look_input = event.relative

func _on_dash_timer_timeout():
	is_dashing = false
	can_move = true

func _on_dash_cooldown_timeout():
	can_dash = true

func _on_throw_cooldown_timeout():
	can_throw = true

func _throw_direction() -> Vector3:
	return -potion_marker.global_transform.basis.z

func raycast_query(point_a : Vector3, point_b : Vector3) -> Dictionary:
	var space_state = get_world_3d().direct_space_state

	# Uses global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(point_a, point_b, 1 << 0)
	query.hit_from_inside = false
	var result = space_state.intersect_ray(query)
	if result:
		DebugDraw._draw_line_relative(point_a, result.position-point_a, 2, Color.PURPLE)
	return result

func _draw_aim() -> void:
	var potion_velocity : Vector3 = _throw_direction() as Vector3
	potion_velocity *= throw_strength

	# How much time in each iteration
	var tstep = 0.05 
	var start_position = potion_marker.global_position
	var line_start = start_position
	var line_end = start_position
	var colours = [Color.RED, Color.GRAY]

	for i in range(1, 151): # from 1 to 5 points of iteration
		potion_velocity.y -= gravity * tstep
		line_end = line_start
		line_end += potion_velocity * tstep

		# Drag calculation
		potion_velocity *= clampf(1.0 - drag * tstep, 0, 1)

		# Check If Hit Wall
		var ray = raycast_query(line_start, line_end)
		if not ray.is_empty():
			break
		
		# Draw Aim Line
		DebugDraw._draw_line_relative(line_start, line_end-line_start, 2, colours[i%2])
		line_start = line_end

func _potion_prep():
	var potion_instance = potion.instantiate()
	potion_marker.add_child(potion_instance)
	potion_instance.global_position = potion_marker.global_position

	if potion_thrown == true:
		potion_instance.top_level = true
		potion_instance.axis_lock_linear_y = false
		potion_instance.set_collision_layer_value(2, true)
		potion_instance.set_collision_mask_value(2, true)
		potion_instance.apply_impulse(_throw_direction() as Vector3 * throw_strength)
		potion_instance.apply_torque(Vector3(1, 0, 0) * 100)
		potion_thrown = false

func _ready():
	# Hide Mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_potion_prep()
	
func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * grav_multiplier * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_velocity = direction * move_speed
	
	if not is_dashing:
		velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)
		
	move_and_slide()

	# Dash Mechanic
	if Input.is_action_just_pressed("dash") and can_move and can_dash and !is_dashing:
		is_dashing = true
		can_move = false
		can_dash = false
		if direction == Vector3.ZERO:
			velocity = dash_speed * -self.global_transform.basis.z.normalized()
		else:
			velocity = dash_speed * direction
		$DashTimer.start()
		$DashCooldown.start()
	
	# Throw Mechanic
	if Input.is_action_just_pressed("throw_potion") and can_throw:
		potion_thrown = true
		_potion_prep()
		can_throw = false
		$ThrowCooldown.start()

	# Draw Throw Trajectory
	if show_trajectory:
		_draw_aim()

	# Camera Look
	rotate_y(-camera_look_input.x * look_sens)
	camera.rotate_x(-camera_look_input.y * look_sens)
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)
	camera_look_input = Vector2.ZERO

	# Mouse on Screen Toggle
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

