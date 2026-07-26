extends Camera2D

@onready var player_2 = $"../../../SubViewportContainer/SubViewport/World/EntityRoot/Player2"

func _process(delta: float) -> void:
	if is_instance_valid(player_2):
		global_position = player_2.global_position
