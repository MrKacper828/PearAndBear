extends Area2D

var button_activated = preload("res://assets/art/world/green_rock_button_activated.png");

signal button_pressed 

var is_pressed : bool = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("normal_rock") and not is_pressed:
		is_pressed = true;
		$Sprite2D.texture = button_activated;
		button_pressed.emit();
