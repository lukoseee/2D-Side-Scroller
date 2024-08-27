extends Node

var start_speed : float  = 2.5
var camSpeed = start_speed
var max_speed = 6
var score  
var speed_modifier = 10000
# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func calculate_speed():
	camSpeed = start_speed +  score / speed_modifier
	
func check_max():
	if camSpeed > max_speed:
		camSpeed = max_speed
		
func update_score():
	score += camSpeed

func reset():
	score = 0 
	camSpeed = start_speed
