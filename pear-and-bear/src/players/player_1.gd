extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const ROCK_SCENE = preload("res://src/players/rock.tscn")

const COYOTE_TIME: float = 0.1
var coyote_timer: float = 0.0

@export var ability_action: String = "ability1"

var facing_direction: float = 1.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump1") and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
	
	var direction := Input.get_axis("move_left1", "move_right1")
	
	if direction:
		velocity.x = direction * SPEED
		$AnimationPlayer.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimationPlayer.play("nothing")

	move_and_slide()

func _process(delta: float) -> void:
	if velocity.x > 0:
		facing_direction = 1.0
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		facing_direction = -1.0
		$Sprite2D.flip_h = true
	
	if Input.is_action_just_pressed("ability1"):
		throw_rock()
		
		
#logika rzutu kamieniem		
func throw_rock() -> void:
	var rock = ROCK_SCENE.instantiate()
	
	rock.global_position = global_position
	var throw_power_x: float = 300.0 * facing_direction
	var throw_power_y: float = -500.0
	rock.velocity = Vector2(throw_power_x, throw_power_y)
	get_parent().add_child(rock)
