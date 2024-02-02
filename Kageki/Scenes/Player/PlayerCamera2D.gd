extends Camera2D
#this code is supposed to be for jittering but I can't tell
#if it works due to the print statement not working
var player : Node2D
var testingx : float
var testing : float
func _ready():
	player = $".." # Replace with the actual path to your player node
	
func _process(delta):
	print(player.is_on_floor())
	update_camera_position()
func update_camera_position():
	if !player.is_on_floor():
		self.global_position = Vector2(self.global_position.x,testing)
	elif player.is_on_floor():
		print("on floor")
		testing = player.global_position.y
		self.global_position = Vector2(self.global_position.x,testing)
	# Vertical camera position does not follow the player's y-coordinate during a jump
	#if is_on_floor(): # Replace with your actual condition for checking if the player is jumping
		#target_position.y = clamp(player.global_position.y, min_y, max_y)

