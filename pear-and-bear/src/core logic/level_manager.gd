extends Node

@onready var level_root: Node2D = $"../SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/World/LevelRoot"
@onready var player_1: CharacterBody2D = $"../SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/World/EntityRoot/Player1"
@onready var player_2: CharacterBody2D = $"../SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/World/EntityRoot/Player2"

@onready var fade_rect: ColorRect = $"../TransitionLayer/TransitionRoot/FadeRect"

func _ready() -> void:
	gate_current_level()
	
func gate_current_level() -> void:
	#wywołanie funkcji po otrzymaniu sygnału
	var gate = level_root.find_child("TransitionGate", true, false)
	if gate and gate.has_signal("gate_activated"):
		if not gate.gate_activated.is_connected(if_gate_activated):
			gate.gate_activated.connect(if_gate_activated)

#zmiana poziomu i spawnowanie graczy
func if_gate_activated(next_level: PackedScene) -> void:
	var tween_in = create_tween()
	tween_in.tween_property(fade_rect, "color:a", 1.0, 0.4)
	await tween_in.finished
	
	for child in level_root.get_children():
		child.queue_free()
		
	var new_level = next_level.instantiate()
	level_root.add_child(new_level)
	
	var spawn_p1 = new_level.find_child("Player1Spawn", true, false)
	var spawn_p2 = new_level.find_child("Player2Spawn", true, false)
	
	if spawn_p1:
		player_1.global_position = spawn_p1.global_position
	if spawn_p2:
		player_2.global_position = spawn_p2.global_position
		
	call_deferred("gate_current_level")
	
	var tween_out = create_tween()
	tween_out.tween_property(fade_rect, "color:a", 0.0, 0.4)
