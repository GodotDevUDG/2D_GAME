extends Area2D


var speed = 200
var direction = Vector2.ZERO


func _ready():
	$AnimatedSprite.play("Bullet")
	
func _process(delta):
	var velocity = direction * speed * delta
	position += velocity

func set_direction(newDir: Vector2):
	direction=newDir.normalized()
 
func _on_VisibilityEnabler2D_screen_exited():
	queue_free();

func start_timer():
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	if body.get_name().substr(0, 6) == "Player":
		$AnimatedSprite.play("Explosion")
		speed=0
		var player = body
		player.suma_vides(-1)
		
	elif body.get_name().substr(0, 4) == "Boss" || body.get_name().substr(0, 4) == "Tile":
		pass
	else:
		print(body.get_name())
		$AnimatedSprite.play("Explosion")
		speed=0
		
	start_timer()
