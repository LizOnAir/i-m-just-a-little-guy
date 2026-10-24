extends Area2D
signal hit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if velocity.y == 0:
		if Input.is_action_pressed("Right"):
			velocity.x = 1
		elif Input.is_action_pressed("Left"):
			velocity.x = -1
	
	if velocity.x == 0:
		if Input.is_action_pressed("Down"):
			velocity.y = 1
		elif Input.is_action_pressed("Up"):
			velocity.y = -1

	if velocity != Vector2.ZERO:
		velocity *= speed
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "move"
		
		if velocity.y < 0:
			$AnimatedSprite2D.rotation_degrees = 0
			$AnimatedSprite2D.flip_v = false
		elif velocity.y > 0:
			$AnimatedSprite2D.rotation_degrees = 0
			$AnimatedSprite2D.flip_v = true

		elif velocity.x < 0:
			$AnimatedSprite2D.rotation_degrees = -90
		elif velocity.x > 0:
			$AnimatedSprite2D.rotation_degrees = 90
		else:
			$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
