extends Node

@onready var label = %Label
@onready var character_body_2d = $"../CharacterBody2D"
@onready var timer = %Timer

var point : int = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_point():
	point += 1
	label.text = "Points: " + str(point)
	
func start_powerup():
	if point == 2:
		print("Starting timer...")
		timer.start()
		print("Timer started: ", timer.is_stopped() == false)
		character_body_2d.SPEED = 200.0

func _on_timer_timeout():
	character_body_2d.SPEED = 150.0
