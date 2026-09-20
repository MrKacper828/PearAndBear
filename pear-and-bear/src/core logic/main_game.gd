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
var exact_cam1_pos: Vector2
var exact_cam2_pos: Vector2
const VERTICAL_CAMERA_OFFSET: Vector2 = Vector2(0, -36.0)

func _ready() -> void:
	#wymuszenie uruchomienia działania kamery dopiero po ruchu fizycznym graczy
	process_physics_priority = 100
	
	#ten sam widok dla viewportu2
	viewport_2.world_2d = viewport_1.world_2d
	#merge kamer
	camera_1.top_level = true
	
	#ustawienie kamery na graczach
	if is_instance_valid(player_1) and is_instance_valid(player_2):
		exact_cam1_pos = (player_1.global_position + player_2.global_position) / 2.0
		exact_cam2_pos = player_2.global_position
		camera_1.global_position = exact_cam1_pos.round()
	
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
		
	var dist_x: float = abs(player_1.global_position.x - player_2.global_position.x)
	var dist_y: float = abs(player_1.global_position.y - player_2.global_position.y)
	
	var should_split: bool = (dist_x > 400.0) or (dist_y > 240.0)
	var should_merge: bool = (dist_x < 350.0) and (dist_y < 200.0)
	
	#przełączanie z marginesem 400px w X i 240px w Y
	if not is_split and should_split:
		is_split = true
		container_2.show()
		divider.show()
	elif is_split and should_merge:
		is_split = false
		container_2.hide()
		divider.hide()
	
	#szybkość przejścia kamery
	var lerp_speed: float = 15.0 * _delta
	#przesunięcie dla celowania
	var p1_offset: Vector2 = player_1.get_camera_offset() if player_1.has_method("get_camera_offset") else Vector2.ZERO
	var p2_offset: Vector2 = player_2.get_camera_offset() if player_2.has_method("get_camera_offset") else Vector2.ZERO
		
	if is_split:
		#tryb dzielonego ekranu
		exact_cam1_pos = exact_cam1_pos.lerp(player_1.global_position + p1_offset + VERTICAL_CAMERA_OFFSET, lerp_speed)
		camera_1.global_position = exact_cam1_pos
		camera_1.zoom = Vector2(1.0, 1.0)
		
		exact_cam2_pos = exact_cam2_pos.lerp(player_2.global_position + p2_offset + VERTICAL_CAMERA_OFFSET, lerp_speed)
		camera_2.global_position = exact_cam2_pos
		camera_2.zoom = Vector2(1.0, 1.0)
	else:
		#tryb jednego ekranu
		var target_p1: Vector2 = player_1.global_position + p1_offset
		var target_p2: Vector2 = player_2.global_position + p2_offset
		var center_pos: Vector2 = (target_p1 + target_p2) / 2.0 + VERTICAL_CAMERA_OFFSET
		exact_cam1_pos = exact_cam1_pos.lerp(center_pos, lerp_speed)
		camera_1.global_position = exact_cam1_pos
		camera_1.zoom = Vector2(1.0, 1.0)
