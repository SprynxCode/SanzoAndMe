extends Camera2D
#this code is supposed to be fot jittering but I can't tell
#if it works due to the print statement not working
@export_category("Follow Character")
@export var player : CharacterBody2D

@export_category("Camera Smoothing")
@export var smoothing_enabled : bool
@export_range(1,10) var smoothing_distance : int = 8

func _physics_process(delta):
	var weight : float
	
	if player != null:
		var camera_position : Vector2
	
		if smoothing_enabled:
			weight = float(11 - smoothing_distance) / 100
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position
		
		print("Weight: ", weight, "Camera Position: ", camera_position, "Camera Pixel Floor", camera_position.floor())
		
