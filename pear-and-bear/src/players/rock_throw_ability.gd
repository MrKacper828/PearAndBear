extends Node

#zmienne do zmiany dla każdego gracza
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
	
