extends Area2D
signal hit # creates custom signal called "hit"

# By exporting we can use this value in the Inspector for other nodes/scenes
@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
		
	# We normalize velocity so moving "down" + "right" with velocity of (1,1) isn't twice as fast as just moving right.
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0 #Use bolean to check velicity
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	
	position += velocity * delta
	# Clamp returns a new vector with elements clamped between minimum and maximum of something
	position = position.clamp(screen_size * 0.05, screen_size * 0.95)
	


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disintegrates after being hit.
	hit.emit() # Send the "hit" signal!
	# Disables collison of player.
	# Just disabling a shape can cause an error if it happens in the middle of the engines collision processing.
	# Using set_deferred tells Godot to wait to disable it until it becomes safe to do
	$CollisionShape2D.set_deferred("disabled", true)
	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
