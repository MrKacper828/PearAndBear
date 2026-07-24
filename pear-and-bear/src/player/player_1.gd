extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const ROCK_SCENE = preload("res://src/player/rock.tscn")

@export var ability_action: String = "ability1"

var facing_direction: float = 1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump1") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left1", "move_right1")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#funkcja zajmująca się ustaleniem kierunku gracza i wywołaniem rzutu
func _process(delta: float) -> void:
	if velocity.x > 0:
		facing_direction = 1.0
	elif velocity.x < 0:
		facing_direction = -1.0
		
	if Input.is_action_just_pressed("ability1"):
		throw_rock()
		
#logika rzutu kamieniem		
func throw_rock() -> void:
	var rock = ROCK_SCENE.instantiate()
	
	rock.global_position = global_position
	var throw_power_x: float = 400.0 * facing_direction
	var throw_power_y: float = -200.0
	rock.velocity = Vector2(throw_power_x, throw_power_y)
	get_tree().root.add_child(rock)
