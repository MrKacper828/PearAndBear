extends StaticBody2D

#po wciśnięciu guzika znikanie drzwi
func open() -> void:
	visible = false #wyłączenie sprite
	$CollisionShape2D.set_deferred("disabled", true) #wyłączenie kolizji
	print("drzwi otwarte")


func _on_button_button_pressed() -> void:
	open()
