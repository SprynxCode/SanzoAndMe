extends CharacterBody2D

#enemy detects palyer
var player_inrange = false
#var player_HurtCD = true
var enemy_inrange = false

#for jumping
const wall_jump_pushback = 500
const wall_slide_gravity = 100
var is_wall_sliding = false
const jump_power = -1000
const gravity = 60

#for moving
const WALK_FORCE = 500
var WALK_MAX_SPEED = 300
const STOP_FORCE = 2300
const JUMP_SPEED = 440

#player attack
const ATTACK_FORCE = 100
#1 = right, -1 = left
var DIRECTION_FACING = 1

#var attack_hitbox: Area2D
@onready var gravity_attack = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprite_node
#player health
@export var player_HurtCD: bool = true # if true, can be hurt
@export var Health: int = 3
@export var hitboxP : CollisionShape2D
@export var facing_left : Vector2
@export var facing_right : Vector2

func _ready():
	sprite_node = get_parent().get_node("Character")
	set_process(true)
	
func direction_update():
	if Input.is_action_just_pressed("move_left"):
		DIRECTION_FACING = -1
		sprite_node.hitboxP.position = facing_left
		$CollisionShape2D/Sprite2D.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		sprite_node.hitboxP.position = facing_right
		DIRECTION_FACING = 1
		$CollisionShape2D/Sprite2D.flip_h = false
	
func _physics_process(delta):
	
	direction_update()
	movement(delta)
	#print(velocity.x)
	
	#Attack Script
	enemy_attack(delta)
	player_attack()
	
	#jump and climb
	jump()
	wall_slide(delta)

#sprite direction when moving

var flag = 0
func _process(delta):
	
	if player_HurtCD == false and flag == 0:
		flag = 1
		cooldown_start()
	#if Health <= 0:
		#queue_free()
	print(velocity.x)

		
func movement(delta):
		
		var walk = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right")) 
		if Input.is_action_pressed("move_left")  and velocity.x > 0 and !is_wall_sliding:
			velocity.x = -50
			pass
		if Input.is_action_pressed("move_right") and velocity.x < 0 and !is_wall_sliding:
			velocity.x = 50
			pass
			
		# Slow down the player if they're not trying to move.
		if abs(walk) < WALK_FORCE * 0.2:
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			velocity.x += walk * delta
		# Clamp to the maximum horizontal movement speed.
		if player_HurtCD == false or is_wall_sliding:
			velocity.x = clamp(velocity.x, -3000, 3000)
		else:
			velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

		# Vertical movement code. Apply gravity.
		velocity.y += gravity * delta

		# Move based on the velocity and snap to the ground.
		# TODO: This information should be set to the CharacterBody properties instead of arguments: snap, Vector2.DOWN, Vector2.UP
		# TODO: Rename velocity to linear_velocity in the rest of the script.
		move_and_slide()

		#previous code for jumpin(t afraid to remove it)
		# Check for jumping. is_on_floor() must be called after movement code.
		#if is_on_floor() and Input.is_action_just_pressed(&"jump"):
			#velocity.y = -JUMP_SPEED * 1
			
			
			
#####-----------------------------------------------------

func cooldown_start():
	if player_HurtCD == false:
		print("coodlown start")
		$HurtCD.start()
		
func _on_hurt_cd_timeout():
	print("Cooldown done")
	player_HurtCD = true
	flag = 0
func enemy_attack(delta):
	
	var player = get_parent().get_node("Character")
	var player_pos = player.global_position
	var enemy = get_parent().get_node("Enemy")
	var enemy_pos = enemy.global_position
	if player_inrange and player_HurtCD:
		print("You are being dddddd!")
		if player_pos.x > enemy_pos.x:
			velocity.x += 1000
			velocity.y += 300
			pass
		elif player_pos.x < enemy_pos.x:
			velocity.x -= 1000
			velocity.y += 300
			pass
		
		
	
func _on_hurtbox_area_entered(area):
	player_inrange = true

func _on_hurtbox_area_exited(area):
	player_inrange = false

######

func player_attack():
	if enemy_inrange and Input.is_action_just_pressed("attack"):
		print("Enemy attacked!")
	elif Input.is_action_just_pressed("attack"):
		print("Attack press")


func _on_right_collision_area_entered(area):
	enemy_inrange = true
	print("In range")
	
func _on_right_collision_area_exited(area):
	enemy_inrange = false
	print("out of range")


#walljumping and sliding
func jump():
	velocity.y += gravity
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_power
		if is_on_wall_only() and Input.is_action_pressed("move_right") :
			velocity.y = jump_power
			velocity.x -= 200
		if is_on_wall_only() and Input.is_action_pressed("move_left") :
			velocity.y = jump_power
			velocity.x += 200
		
func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
			
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
		
		
#####################
	



	


