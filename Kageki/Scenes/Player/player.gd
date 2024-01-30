extends CharacterBody2D

const WALK_FORCE = 700
const WALK_MAX_SPEED = 500
const STOP_FORCE = 2300
const JUMP_SPEED = 400
const ATTACK_FORCE = 100

var attack_hitbox: Area2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right")) 
	if Input.is_action_pressed("move_left")  and velocity.x > 0:
		velocity.x = -50
		
	if Input.is_action_pressed("move_right") and velocity.x < 0:
		velocity.x = 50
		
	#attack
	if Input.is_action_just_pressed("attack"):
		perform_attack()
	
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
	
func perform_attack():
	print("attack")
	
func _ready():
	#attack_hittbox = $AttackHitbox
	#attack_hitbox.set.collision_layer_bit(1, true)
	#attack_hitbox.set
	print(" ")
	
	
