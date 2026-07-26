extends Node

@onready var container_1: SubViewportContainer = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer"
@onready var container_2: SubViewportContainer = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer2"
@onready var divider: ColorRect = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/Divider"

@onready var viewport_1: SubViewport = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport"
@onready var viewport_2: SubViewport = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer2/SubViewport"

@onready var player_1: CharacterBody2D = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/World/EntityRoot/Player1"
@onready var player_2: CharacterBody2D = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/World/EntityRoot/Player2"

@onready var camera_1: Camera2D = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/World/EntityRoot/Player1/Camera2D"
@onready var camera_2: Camera2D = $"SplitPlayerCamera/CanvasLayer/HBoxContainer/SubViewportContainer2/SubViewport/Camera2D"

var is_split: bool = false

func _ready() -> void:
	#ten sam widok dla viewportu2
	viewport_2.world_2d = viewport_1.world_2d
	#merge kamer
	camera_1.top_level = true
	
	#ukrycie splitu na starcie gry
	is_split = false
	container_2.hide()
	divider.hide()
	
	#kamera na środku
	if is_instance_valid(player_1) and is_instance_valid(player_2):
		camera_1.global_position = ((player_1.global_position + player_2.global_position) / 2.0).round()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player_1) or not is_instance_valid(player_2):
		return
		
	var distance: float = player_1.global_position.distance_to(player_2.global_position)
	
	#przełączanie z marginesem 350-400px
	if not is_split and distance > 400.0:
		is_split = true
		container_2.show()
		divider.show()
	elif is_split and distance < 350.0:
		is_split = false
		container_2.hide()
		divider.hide()
	
	#szybkość przejścia kamery
	var lerp_speed: float = 15.0 * _delta
		
	if is_split:
		#tryb dzielonego ekranu
		var target_1: Vector2 = camera_1.global_position.lerp(player_1.global_position, lerp_speed)
		camera_1.global_position = target_1.round()
		camera_1.zoom = Vector2(1.0, 1.0)
		
		var target_2: Vector2 = camera_2.global_position.lerp(player_2.global_position, lerp_speed)
		camera_2.global_position = target_2.round()
		camera_2.zoom = Vector2(1.0, 1.0)
	else:
		#tryb jednego ekranu
		var center_pos: Vector2 = (player_1.global_position + player_2.global_position) / 2.0
		var target_center: Vector2 = camera_1.global_position.lerp(center_pos, lerp_speed)
		camera_1.global_position = target_center.round()
		camera_1.zoom = Vector2(1.0, 1.0)
