extends CharacterBody2D


const WALK_FORCE = 100
const WALK_MAX_SPEED = 55
const STOP_FORCE = 2300
const JUMP_SPEED = 400
const ATTACK_FORCE = 100
var isColliding = false
const SPEED = 5.0
const JUMP_VELOCITY = -400.0
const HP = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var DIRECTION_FACING = 1
var sprite_node : Node
var player
var enemy
var in_range = false

@export var facing_left : Vector2
@export var facing_right : Vector2
@export var hitbox : CollisionShape2D
signal face_direction (facing_right : bool)

func _ready():
	player = get_parent().get_node("Character")
	enemy = get_parent().get_node("Enemy")

func direction_update():
	#UPDATES THE DIRECTIONSSHJSHSHSHSSHShysSWHYGWh
	if velocity.x > 0:
		$Sprite2D.flip_h = true
		enemy.hitbox.position = enemy.facing_right
	if velocity.x < 0:
		$Sprite2D.flip_h = false
		enemy.hitbox.position = enemy.facing_left
		
		
	
func _process(delta):
	#GETS THE POSITIONSSSSSSSSSSSSSSSSSS in the SCENEEE
	var player_pos = player.global_position
	var enemy_pos = enemy.global_position
	
	
	direction_update()

	#####	
	if player_pos.x > enemy_pos.x and (player_pos.x - enemy_pos.x) > 30:
		velocity.x += 5
	elif player_pos.x < enemy_pos.x and (player_pos.x - enemy_pos.x) <  -30:
		velocity.x -= 5
	else:
		velocity.x = 0

	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

		# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta
	#var test = preload("res://Scenes/Player/player.gd").new()
	#var shared_var = test.player_pos

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if in_range:
		attack()
	move_and_slide()
func movement(delta):
		var walk = WALK_FORCE * DIRECTION_FACING
		if velocity.x > 0:
			velocity.x = walk
			
		
		# Slow down the player if they're not trying to move.
		if abs(walk) < WALK_FORCE * 0.2:
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			velocity.x += walk * delta
		# Clamp to the maximum horizontal movement speed.
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

		# Vertical movement code. Apply gravity.
		velocity.y += gravity * delta

		# Move based on the velocity and snap to the ground.
		# TODO: This information should be set to the CharacterBody properties instead of arguments: snap, Vector2.DOWN, Vector2.UP
		# TODO: Rename velocity to linear_velocity in the rest of the script.
		move_and_slide()

		# Check for jumping. is_on_floor() must be called after movement code.
		if is_on_floor() and Input.is_action_just_pressed(&"jump"):
			velocity.y = -JUMP_SPEED

func _on_hit_left_area_entered(area):
	in_range = true

func _on_attack_area_exited(area):
	in_range= false

func attack():
	if player.player_HurtCD and in_range:
		player.player_HurtCD = false
		player.Health -= 1
		print("Hit")
