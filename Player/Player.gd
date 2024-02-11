extends CharacterBody2D

var max_speed: float = 300.0
var acceleration: float = 1000.0
var friction: float = 1000.0

var horzDir = 0
var vertDir = 0

#func _ready():
#	get_node("AnimatedSprite2D").play("Walk Left")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		

func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = get_input_vector()
	if input_vector != Vector2.ZERO:
		if horzDir > 0:
			get_node("AnimatedSprite2D").play("walkright")
		elif horzDir < 1:
			get_node("AnimatedSprite2D").play("Walk Left")
		elif vertDir > 0:
			get_node("AnimatedSprite2D").play("walk forward")
		elif vertDir < 1:
			get_node("AnimatedSprite2D").play("walk back")
		
		
		apply_movement(input_vector, delta)
		
	else:
		apply_friction(delta)
		if velocity.length() <= 0:
			get_node("AnimatedSprite2D").stop()
		
		
	
	# Call move_and_slide() with no arguments
	move_and_slide()

func get_input_vector() -> Vector2:
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	horzDir = Input.get_axis("ui_left","ui_right")
	vertDir = Input.get_axis("ui_up","ui_down")
	return input_vector.normalized()

func apply_friction(delta: float) -> void:
	if velocity.length() > 0:
		velocity -= velocity.normalized() * friction * delta
		velocity = velocity.limit_length(max(velocity.length() - friction * delta, 0))

func apply_movement(input_vector: Vector2, delta: float) -> void:
	velocity += input_vector * acceleration * delta
	velocity = velocity.limit_length(max_speed)
