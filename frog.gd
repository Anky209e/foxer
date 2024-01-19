extends CharacterBody2D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("../../Player/Player")
@onready var enemy = get_node(".")


var speed = 100
var chase = false

func _ready():
	get_node("AnimatedSprite2D").play('idle')

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	if chase == true:
		var direction = (player.global_position - self.global_position).normalized()
		if get_node("AnimatedSprite2D").animation != 'death':
			get_node("AnimatedSprite2D").play("jump")
		print(direction)
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * speed
	else:
		if get_node("AnimatedSprite2D").animation != 'death':
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0
	
	move_and_slide()



func _on_frog_roa_body_entered(body):
	if body.name == 'Player':
		chase = true

func _on_frog_roa_body_exited(body):
	if body.name == 'Player':
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		chase = false
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()

func death():
	chase = false
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
	

func _on_player_collision_body_entered(body):
	if body.name == "Player":
		body.health -= 15
		death()
