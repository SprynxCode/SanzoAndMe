extends Camera2D
#this code is supposed to be for jittering but I can't tell
#if it works due to the print statement not working
var player : Node2D
var testingx : float
var testing : float
func _ready():
	player = $".." # Replace with the actual path to your player node
	
func update_camera_position():
	if !player.is_on_floor():
		self.position_smoothing_speed = 5
		print(self.position_smoothing_speed)
	elif player.is_on_floor():
		self.position_smoothing_speed = 2
		print(self.position_smoothing_speed)
		
		
func _process(delta):#
	update_camera_position()
		
	# Vertical camera position does not follow the player's y-coordinate during a jump
	#if is_on_floor(): # Replace with your actual condition for checking if the player is jumping
		#target_position.y = clamp(player.global_position.y, min_y, max_y)

