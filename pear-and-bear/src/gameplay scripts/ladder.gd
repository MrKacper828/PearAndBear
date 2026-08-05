extends Area2D

#punkt docelowy
@onready var top_position = $top

var players_in_area: Array = []

func _on_body_entered(body) -> void:
	if body.name == "Player1" or body.name == "Player2": 
		if not players_in_area.has(body):
			players_in_area.append(body)

func _on_body_exited(body) -> void:
	if players_in_area.has(body):
		players_in_area.erase(body)

func _process(delta) -> void:
	for player in players_in_area:
		if player.name == "Player1" and Input.is_action_just_pressed("interaction1"):
			climb(player)
		elif player.name == "Player2" and Input.is_action_just_pressed("interaction2"):
			climb(player)
		
func climb(player) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", top_position.global_position, 0.8)
