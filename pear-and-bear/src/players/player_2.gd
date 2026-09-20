extends CharacterBody2D


const SPEED = 180.0
const JUMP_VELOCITY = -380.0

const COYOTE_TIME: float = 0.1
var coyote_timer: float = 0.0

@export var ability_action: String = "ability2"

var facing_direction: float = 1.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump2") and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
	
	var direction := Input.get_axis("move_left2", "move_right2")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		$AnimationPlayer.play("jump2")
	elif direction != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("nothing2")
	move_and_slide()

#funkcja zajmująca się ustaleniem kierunku gracza i wywołaniem rzutu
func _process(delta: float) -> void:
	if velocity.x > 0:
		facing_direction = 1.0
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		facing_direction = -1.0
		$Sprite2D.flip_h = true
		
	if has_node("CurrentAbility"):
		$CurrentAbility.execute(delta, facing_direction, ability_action)

func get_camera_offset() -> Vector2:
	if has_node("CurrentAbility") and $CurrentAbility.has_method("get_aim_offset"):
		return $CurrentAbility.get_aim_offset()
	return Vector2.ZERO
