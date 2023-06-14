extends KinematicBody2D

var hits : int

var maxSpeed = 30
const gravity = 15
var motion = Vector2()
onready var Enemy = $AnimatedSprite
var hit=0
var floorDetection=true;


func _ready():
	Enemy.play("Run")
	Enemy.scale.x*= -1
	motion.x = -maxSpeed
	
	
func _process(delta):
	if(playerDetection()):
		
		maxSpeed=80
		if(motion.x<0):
			motion.x=-maxSpeed
		else:
			motion.x=maxSpeed
	else:
		maxSpeed=30
		if(motion.x<0):
			motion.x=-maxSpeed
		else:
			motion.x=maxSpeed

func _flip():
	
	if str($LeftRay.get_collider()).substr(0, 6) == "Player":
		$LeftRay.get_collider().suma_vides(-1)
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	elif str($RightRay.get_collider()).substr(0, 6) == "Player":
		$RightRay.get_collider().suma_vides(-1)
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	elif str($TopRay.get_collider()).substr(0, 6) == "Player":
		$TopRay.get_collider().suma_vides(-1)
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	elif $LeftRay.is_colliding() or $RightRay.is_colliding() or !$AnimatedSprite/FloorDetection.is_colliding() && floorDetection:
		motion.x *= -1
		Enemy.scale.x *= -1
		$PlayerDetection.transform.x*=-1
	
func _physics_process(delta):
	motion.y += gravity
	_flip()
	motion = move_and_slide(motion)

func Damage_Gun():
	Enemy.stop()
	Enemy.play("Damage")
	var dir = motion.x
	motion.x = 0
	yield(Enemy,"animation_finished")
	motion.x = dir
	Enemy.play("Run")

func playerDetection():
	var detected = false
	if(str($PlayerDetection.get_collider()).substr(0, 6) == "Player"):
		detected=true;
	
	return detected;

func changeFloorDetection():
	floorDetection=!floorDetection
