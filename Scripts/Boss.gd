extends KinematicBody2D


export (PackedScene) var shoot

var hits : int

var maxSpeed = 30
const gravity = 15
var motion = Vector2()
onready var Enemy = $AnimatedSprite
var hit=0
var floorDetection=false;
var isShooting = true
var direction = false
var velocityIncrease=0

func _ready():
	Enemy.play("Run")
	Enemy.scale.x*= -1
	motion.x = -maxSpeed
	$Shoot.transform.x*=-1
	shoot()
	
func shoot():
	yield(get_tree().create_timer(3.0), "timeout")
	isShooting = false
	$AnimatedSprite.stop()
	$AnimatedSprite.play("Shoot")
	$Walk.playing = false
	$Shooting.playing = true
	motion.x /= 1000
	yield($AnimatedSprite,"animation_finished")
	$Walk.playing = true
	
	
	var target = self.get_parent().get_child(7).position
	target.y+=6;
	var direction = (target-position).normalized()
	var shoot_bullet = shoot.instance()
	shoot_bullet.set_direction(direction)

	shoot_bullet.global_position = $Shoot/Direction.global_position
	get_tree().call_group("World","add_child",shoot_bullet)
	$AnimatedSprite.play("Run")
	isShooting = true
	shoot()

func _process(delta):
	if isShooting:
		if(playerDetection()):
			maxSpeed=80
			if(motion.x<0):
				motion.x=-maxSpeed-velocityIncrease
			else:
				motion.x=maxSpeed+velocityIncrease
		else:
			maxSpeed=30
			if(motion.x<0):
				motion.x=-maxSpeed-velocityIncrease
			else:
				motion.x=maxSpeed+velocityIncrease
func _flip():
	if str($LeftRay.get_collider()).substr(0, 6) == "Player":
		direction = !direction
		$LeftRay.get_collider().suma_vides(-1)
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	elif str($RightRay.get_collider()).substr(0, 6) == "Player":
		direction = !direction
		$RightRay.get_collider().suma_vides(-1)
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	elif str($TopRay.get_collider()).substr(0, 6) == "Player":
		direction = !direction
		$TopRay.get_collider().suma_vides(-1)
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	elif $LeftRay.is_colliding() or $RightRay.is_colliding() or !$AnimatedSprite/FloorDetection.is_colliding() && floorDetection:
		direction = !direction
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	
func _physics_process(delta):
	motion.y += gravity
	if(isShooting):
		var target = self.get_parent().get_child(7).position
		var direction = (target-position).normalized()
		var ogMotion = motion.x
		motion.x=direction.x*maxSpeed
		if(ogMotion < 0 && motion.x > 0 || ogMotion > 0 && motion.x < 0):
			direction = !direction
			Enemy.scale.x *= -1
			$PlayerDetection.transform.x*=-1
			$Shoot.transform.x*=-1
	
	_flip()
	
	motion = move_and_slide(motion)

func auxFlip():
	if str($LeftRay.get_collider()).substr(0, 6) == "Player":
		$LeftRay.get_collider().suma_vides(-1)

func Damage_Gun():
	Enemy.stop()
	Enemy.play("Damage")
	yield(Enemy,"animation_finished")
	Enemy.play("Run")

func playerDetection():
	var detected = false
	if(str($PlayerDetection.get_collider()).substr(0, 6) == "Player"):
		detected=true;
	
	return detected;

func changeFloorDetection():
	floorDetection=!floorDetection
