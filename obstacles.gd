extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_stone_1_body_entered(body):
	if (body.name == "CharacterBody2D"):
		get_tree().reload_current_scene()


func _on_stone_3_body_entered(body):
	if (body.name == "CharacterBody2D"):
		get_tree().reload_current_scene()
