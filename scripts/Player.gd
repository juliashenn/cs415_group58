extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		update_run_animation(direction)
	else:
		velocity = Vector2.ZERO
		
	if Input.is_action_just_released("ui_right"):
		animated_sprite.play("idleRight")
	if Input.is_action_just_released("ui_left"):
		animated_sprite.play("idleLeft")
	if Input.is_action_just_released("ui_down"):
		animated_sprite.play("idleFront")
	if Input.is_action_just_released("ui_up"):
		animated_sprite.play("idleBack")
	move_and_slide()
	
func update_run_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("runRight")
		else:
			animated_sprite.play("runLeft")
	else:
		if direction.y > 0:
			animated_sprite.play("runFront")
		else:
			animated_sprite.play("runBack")
			
func update_sit_animation(direction: bool):
	if direction:
		animated_sprite.play("sitRight")
	else:
		animated_sprite.play("sitLeft")
		
func update_animation(ani: String):
	animated_sprite.play(ani)
