extends Area2D

var number_of_players: int = 0

signal gate_activated(next_level_scene: PackedScene)

#pole na nowe strefy
@export var next_level: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		number_of_players += 1
		
		#wysłanie sygnału o zmianie poziomu na następny
		if number_of_players == 2 and next_level != null:
			gate_activated.emit(next_level)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		number_of_players -= 1
