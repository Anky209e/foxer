extends CharacterBody2D


const SPEED = 320.0
const JUMP_VELOCITY = -400.0
var health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var playerAnimationNode = get_node("AnimationPlayer")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playerAnimationNode.play('jump')

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1: 
		get_node('AnimatedSprite2D').flip_h = true
	elif direction == 1:
		get_node('AnimatedSprite2D').flip_h = false
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			playerAnimationNode.play('run')
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			playerAnimationNode.play('idle')
	if velocity.y > 0:
		playerAnimationNode.play('fall')
		

	move_and_slide()
	
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file('res://main.tscn')
