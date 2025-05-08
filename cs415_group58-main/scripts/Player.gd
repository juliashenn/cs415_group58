extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var world = get_parent()
var holdingObject = false

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
		updateObjectPosition(2)
	if Input.is_action_just_released("ui_left"):
		animated_sprite.play("idleLeft")
		updateObjectPosition(1)
	if Input.is_action_just_released("ui_down"):
		animated_sprite.play("idleFront")
		updateObjectPosition(0)
	if Input.is_action_just_released("ui_up"):
		animated_sprite.play("idleBack")
		updateObjectPosition(3)
	move_and_slide()
	
#	if has_node("Food") and Input.is_action_just_pressed("interact") and world :
#		dropItem()
	
func update_run_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("runRight")
			updateObjectPosition(2)
		else:
			animated_sprite.play("runLeft")
			updateObjectPosition(1)
	else:
		if direction.y > 0:
			animated_sprite.play("runFront")
			updateObjectPosition(0)
		else:
			animated_sprite.play("runBack")
			updateObjectPosition(3)
func update_sit_animation(direction: bool):
	if direction:
		animated_sprite.play("sitRight")
		updateObjectPosition(2)
	else:
		animated_sprite.play("sitLeft")
		updateObjectPosition(1)
		
func update_animation(ani: String):
	animated_sprite.play(ani)

func updateObjectPosition(direction: int): # 0 for center, 1 for when player faces left, 2 when facing right, 3 for back
	var object = null
	for child in get_children():
		if child is Food:
			object = child
		elif child is Plate:
			object = child
	if object:
		if not object:
			object = $Plate
		if direction == 0:
			object.position = Vector2(0, 11)
			object.z_index = 0
		elif direction == 1:
			object.position = Vector2(-7, 11)
			object.z_index = 0
		elif direction == 2:
			object.position = Vector2(7, 11)
			object.z_index = 0
		elif direction == 3:
			object.position = Vector2(-2.5, 5.5)
			object.z_index = -1
			
func dropObject():
	if holdingObject:
#		print("dropping")
		var obj_ref
		for child in get_children():
			if child is Food:
				obj_ref = child
			elif child is Plate:
				obj_ref = child
#		if has_node("Food"):
#			obj_ref = $Food
#		elif has_node("Plate"):
#			obj_ref = $Plate
		if obj_ref == null:
			holdingObject = false
			return
		var pos = obj_ref.global_position
		remove_child(obj_ref)
		world.add_child(obj_ref)
		obj_ref.global_position = pos
		obj_ref.z_index = 0
		holdingObject = false
		obj_ref.scale = Vector2(1, 1)

	
#func giveFood():
#	if holdingObject and has_node("Food"):
#		var path = $Food.getFood()
#		holdingObject = false
#		$Food.queue_free()
#		return path
