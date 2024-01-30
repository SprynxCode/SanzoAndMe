extends CharacterBody2D

const WALK_FORCE = 700
var WALK_MAX_SPEED = 500
const STOP_FORCE = 2300
const JUMP_SPEED = 400
const ATTACK_FORCE = 100
#1 = right, -1 = left
var DIRECTION_FACING = 1

var attack_hitbox: Area2D
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprite_node

func _ready():
	sprite_node = get_node("Character")
	set_process(true)
	
func _physics_process(delta):

	#Movement + Jump
	movement(delta)
	#Attack Script
	enemy_attack()
	player_attack()

	if Input.is_action_just_pressed("move_left"):
		DIRECTION_FACING = -1
		$LeftCollision.monitoring = true
		$RightCollision.monitoring = false
		$CollisionShape2D/Sprite2D.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		DIRECTION_FACING = 1
		$LeftCollision.monitoring = false
		$RightCollision.monitoring = true
		$CollisionShape2D/Sprite2D.flip_h = false

	
func movementTest(delta):
	pass

func movement(delta):
		var walk = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right")) 
		if Input.is_action_pressed("move_left")  and velocity.x > 0:
			velocity.x = -50
			
		if Input.is_action_pressed("move_right") and velocity.x < 0:
			velocity.x = 50
		
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
			
#####-----------------------------------------------------
var player_inrange = false
var player_HurtCD = true
var enemy_inrange = false


func enemy_attack():
	var player = get_parent().get_node("Character")
	var player_pos = player.global_position
	var enemy = get_parent().get_node("Enemy")
	var enemy_pos = enemy.global_position
	if player_inrange and player_HurtCD:
		print("You are being hit!")
		if player_pos.x > enemy_pos.x:
			velocity.x += 1000
			WALK_MAX_SPEED = 0
			pass
		elif player_pos.x < enemy_pos.x:
			velocity.x -= 1000
			WALK_MAX_SPEED = 0
			pass
		player_HurtCD = false
		$HurtCD.start()
	
func _on_hurtbox_area_entered(area):
	print("Player is in enemy range")
	player_inrange = true

func _on_hurtbox_area_exited(area):
	print("Player is outside enemy range")
	player_inrange = false

######

func player_attack():
	if enemy_inrange and Input.is_action_just_pressed("attack"):
		print("Enemy attacked!")

func _on_hurt_cd_timeout():
	print("Cooldown done")
	WALK_MAX_SPEED = 500
	player_HurtCD = true

func _on_right_collision_area_entered(area):
	print("In range")
	enemy_inrange = true

func _on_right_collision_area_exited(area):
	print("Out of range")
	enemy_inrange = false

func _on_left_collision_area_entered(area):
	print("In range")
	enemy_inrange = true

func _on_left_collision_area_exited(area):
	print("In range")
	enemy_inrange = false
