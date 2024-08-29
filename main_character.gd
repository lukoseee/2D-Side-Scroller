extends CharacterBody2D

enum State {
	RUNNING,
	JUMPING,
	SLIDING,
	SHOOTING,
	ATTACKING
}

var current_state = State.RUNNING

var SPEED = 200.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d = $Sprite2D
#collision shapes
@onready var running = $Running
@onready var sliding = $Sliding
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var main = $".."
var enemy1 = preload("res://enemies/enemy1.tscn")
@onready var camera_2d = $"../Camera2D"

func _ready():
	animation_player.active = true
	

func _physics_process(delta):
	#animations
	
	velocity.y += gravity * delta
	var state_machine = animation_tree["parameters/playback"]
	
	state_machine.travel("Start")
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if not get_tree().paused:
			print("Unpaused")
		else:
			print("Paused")
		#
	if is_on_floor() and main.game_running:
		
		if Input.is_action_just_pressed("up"):
			
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_pressed("slide"):
			#
			state_machine.travel("slide")
			running.disabled = true
			
			
		elif Input.is_action_just_pressed("shoot"):
			
			#stops players shooting constantly
			if state_machine.get_current_node() == "run":
				main.spawn_bullet(self.position.x , self.position.y)
				
			#reposition the player so he doeesnt move back frames
			self.position.x += 2
			state_machine.travel("gun")
			
			
		elif Input.is_action_just_pressed("attack"):
			
			state_machine.travel("attack")
			
			
		else:
			if state_machine.get_current_node() != "slide" :
				running.disabled = false
			state_machine.travel("run")
			
	else:
		
		#animation_player.play("jump")
		state_machine.travel("jump")
		
	var screen_size = get_window().size
	var body_width = self.get_node("Running").shape.radius * 2
	var body_height = self.get_node("Running").shape.height
	
	if ( (self.position.x + body_width) < (camera_2d.position.x - screen_size.x/2) ) or ( (self.position.y + body_height) > (camera_2d.position.y + screen_size.x/2) ):
		main.game_over()
	
	
	move_and_slide()
	
	
	
