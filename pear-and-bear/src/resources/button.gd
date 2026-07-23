extends Area2D

signal button_pressed 

var current_player = null
var is_pressed : bool = false

func _on_body_entered(body) -> void:
	if body.name == "Player1" or body.name == "Player2": 
		current_player = body

func _on_body_exited(body) -> void:
	if body.name == "Player1" or body.name == "Player2":
		current_player = body

func _process(delta) -> void:
	if current_player != null and not is_pressed:
		if current_player.name == "Player1" and Input.is_action_just_pressed("interaction1"):
			is_pressed = true
			button_pressed.emit()
		elif current_player.name == "Player2" and Input.is_action_just_pressed("interaction2"):
			is_pressed = true
			button_pressed.emit()
