extends CharacterBody2D

@onready var life_2 = $"Life 2"

var SPEED = 700
var enemy1 = preload("res://enemies/enemy1.tscn")
var enemies = [enemy1]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	self.position.x += SPEED * delta


func _on_area_2d_body_entered(body):
	var substring = "enemy"
	var subtstring2 = "CharacterBody2D"
	if (substring in body.name or subtstring2 in body.name):
		#start bullet lifetime when its hits enemy - disintegrates once half way through the enemy sprite 
		print("hit")
		life_2.start()


func _on_timer_timeout():
	queue_free()


func _on_life_2_timeout():
	queue_free()
