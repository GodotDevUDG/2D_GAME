extends Area2D


var velocity : int


func _ready():
	$AnimatedSprite.play("Bullet")
	
func _process(delta):
	global_position.x += velocity*delta
 
func _on_VisibilityEnabler2D_screen_exited():
	queue_free();

func start_timer():
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	if body.get_name().substr(0, 5) == "Enemy":
		$AnimatedSprite.play("Explosion")
		body.Damage_Gun()
		velocity=0
		var enemy = body
		enemy.hits += 1
		if enemy.hits == 3:
			body.queue_free()
	else:
		$AnimatedSprite.play("Explosion")
		velocity=0
		
	start_timer()
