extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#new_game() # LETS GOOO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	
	# Clears all mobs from screen when you press play again
	get_tree().call_group("mobs", "queue_free")
	
	# start background music
	$Music.play()

func _on_mob_timer_timeout() -> void:
	#Create new mob
	var mob = mob_scene.instantiate()
	
	# Choose random spawn location on Path2D
	var mob_spawn_loc = $ModPath/MobSpawnLocation
	mob_spawn_loc.progress_ratio = randf() # Random float between 0 and 1.
	
	# Set mob direction perpendicular to the path direction
	var direction = mob_spawn_loc.rotation + PI / 2
	
	# set mob position to random location
	mob.position = mob_spawn_loc.position
	
	# Add some randomness to direction
	# Why PI?
	# Godot uses Radians, not degrees.
	# Pi represents half a turn in radians. Oooooh.
	direction += randf_range(-PI / 4, PI / 4) #Huh?
	mob.rotation = direction
	
	# choose the velocity of the new mob
	var velocity = Vector2(randf_range(150, 250), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn it to main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
