extends Node

var score
var high_score = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_score():
	score += 1

func reset():
	score = 0

func update():
	high_score = score
