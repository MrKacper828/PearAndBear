extends Area2D

var velocity: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += get_gravity() * delta
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
