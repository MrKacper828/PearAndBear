extends Area2D

var ladder_activated = preload("res://assets/art/world/rope_ladder_long.png");

signal rope_burned

var is_burned : bool = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("fire_rock") and not is_burned:
		is_burned = true;
		$"../Sprite2Dladder".texture = ladder_activated;
		$"../Sprite2Dladder".position.y = 77.0
		$Sprite2Drope.visible = false;
		$"../CollisionShape2Dladder".shape = $"../CollisionShape2Dladder".shape.duplicate()
		$"../CollisionShape2Dladder".shape.size = Vector2(64, 192)
		$"../CollisionShape2Dladder".position.y = 96.0
		rope_burned.emit();
