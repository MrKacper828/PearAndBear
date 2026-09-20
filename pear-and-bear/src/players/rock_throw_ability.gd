extends Node

@onready var line_2d: Line2D = $Line2D
var aim_offset: Vector2 = Vector2.ZERO

#zmienne dla każdego gracza w inspektorze
@export var rock_scene: PackedScene

@export var max_charge_time: float = 1.0
@export var min_power_x: float = 150.0
@export var max_power_x: float = 450.0
@export var min_power_y: float = -250.0
@export var max_power_y: float = -650.0

var charge_time: float = 0.0
var is_charging: bool = false

#wywołanie abilitki
func execute(delta: float, facing_direction: float, action_name: String) -> void:
	#ładowanie siły rzutu
	if Input.is_action_just_pressed(action_name):
		is_charging = true
		charge_time = 0.0
	
	if is_charging and Input.is_action_pressed(action_name):
		charge_time += delta
		charge_time = min(charge_time, max_charge_time)
	
	if is_charging and Input.is_action_just_released(action_name):
		throw_rock(charge_time, facing_direction)
		is_charging = false

#rzucanie kamieniem
func throw_rock(held_time: float, facing_direction: float) -> void:
	if rock_scene == null:
		return
		
	var rock = rock_scene.instantiate()
	rock.global_position = get_parent().global_position
	
	var final_power_x: float = remap(held_time, 0.0, max_charge_time, min_power_x, max_power_x) * facing_direction
	var final_power_y: float = remap(held_time, 0.0, max_charge_time, min_power_y, max_power_y)
	
	rock.velocity = Vector2(final_power_x, final_power_y)
	get_parent().get_parent().add_child(rock)
	
#linia widoczności trajektorii rzutu + przesunięcie kamery w stronę rzutu
func _process(delta: float) -> void:
	if is_charging:
		line_2d.visible = true
		update_trajectory_line()
		var current_power_x = remap(charge_time, 0.0, max_charge_time, min_power_x, max_power_x) * get_parent().facing_direction
		var current_power_y = remap(charge_time, 0.0, max_charge_time, min_power_y, max_power_y)
		var target_offset = Vector2(current_power_x * 0.25, current_power_y * 0.25)
		aim_offset = aim_offset.lerp(target_offset, 10.0 * delta)
	else:
		line_2d.visible = false
		aim_offset = aim_offset.lerp(Vector2.ZERO, 10.0 * delta)
		
func update_trajectory_line() -> void:
	line_2d.clear_points()
	
	var start_pos: Vector2 = get_parent().global_position
	
	var current_power_x = remap(charge_time, 0.0, max_charge_time, min_power_x, max_power_x) * get_parent().facing_direction
	var current_power_y = remap(charge_time, 0.0, max_charge_time, min_power_y, max_power_y)
	
	var sim_pos: Vector2 = start_pos
	var sim_vel: Vector2 = Vector2(current_power_x, current_power_y)
	var gravity: float = 980.0
	
	var step_dt: float = 0.05
	
	for i in range(25):
		line_2d.add_point(line_2d.to_local(sim_pos))
		
		sim_vel.y += gravity * step_dt
		sim_pos += sim_vel * step_dt
		
func get_aim_offset() -> Vector2:
	return aim_offset
