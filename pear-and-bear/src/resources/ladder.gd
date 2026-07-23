extends Area2D

#punkt docelowy
@onready var top_position = $top

var current_player = null

func _on_body_entered(body):
	if body.name == "Player1" or body.name == "Player2": 
		current_player = body

func _on_body_exited(body):
	if body.name == "Player1" or body.name == "Player2": 
		current_player = null

func _process(delta):
	if current_player != null and (Input.is_action_just_pressed("interaction1") or Input.is_action_just_pressed("interaction2")):
		var tween = get_tree().create_tween()
		tween.tween_property(current_player, "global_position", top_position.global_position, 0.5)
