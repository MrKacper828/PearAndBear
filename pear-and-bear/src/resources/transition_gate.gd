extends Area2D

var number_of_players: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if number_of_players == 2:
		#animacja przejścia
		#sygnał na zmianę poziomu
		pass


func _on_body_entered(body: Node2D) -> void:
	number_of_players += 1


func _on_body_exited(body: Node2D) -> void:
	number_of_players -= 1
