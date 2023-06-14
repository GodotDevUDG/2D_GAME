class_name Personatge extends KinematicBody2D

export (PackedScene) var bullet
export (PackedScene) var specialbullet
const moveSpeed = 25
export var maxSpeed = 80

const jumpHeight = -320
const up = Vector2(0,-1)
const gravity = 15

onready var animatedSprite = $AnimatedSprite
var _posInicial: Vector2
export var _nvides:= 3 
var motion = Vector2()
var isShooting = false;
var cooldownShoot = 0;

var highShoot = false;

func set_pos_start(pos:Vector2):
	position = pos
	_posInicial = pos

func _respawn():
	position = _posInicial
	motion = Vector2()

func suma_vides(vidas:int):
	_nvides += vidas
	if _nvides == 0:
		get_tree().change_scene("res://Scenes/End.tscn") 
	elif vidas < 0: 
		 _respawn()
	$Sprite/Vidas.set_text(str(_nvides))


func _physics_process(delta):
	
	motion.y += gravity
	var friction = false
	cooldownShoot+=delta
	
	if Input.is_action_just_pressed("ui_accept"):
		shootBullet()
		cooldownShoot=0
		isShooting=true;
		
	if(cooldownShoot>0.3):
		isShooting=false
	
	if Input.is_action_just_pressed("ui_shift") and highShoot:
		shootSpecialBullet()
		cooldownShoot=0
		isShooting=true;
		highShoot = false
		restaurar_energia()
	
	
	if Input.is_action_pressed("ui_up"):
		if(isShooting):
			animatedSprite.play("RunShoot")
		else:
			animatedSprite.play("Jump")

	elif Input.is_action_pressed("ui_right"):
		animatedSprite.flip_h = false
		if(isShooting):
			animatedSprite.play("RunShoot")
		else:
			animatedSprite.play("Run")
		motion.x = min(motion.x + moveSpeed,maxSpeed)

	elif Input.is_action_pressed("ui_left"):
		animatedSprite.flip_h = true
		if(isShooting):
			animatedSprite.play("RunShoot")
		else:
			animatedSprite.play("Run")
		motion.x = max(motion.x - moveSpeed,-maxSpeed)	
	else:
		if(isShooting):
			animatedSprite.play("Shoot")
		else:
			animatedSprite.play("Idle")
		friction = true 
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = jumpHeight
		if friction == true:
			motion.x = lerp(motion.x,0,0.5)
	else:
		if friction==true:
			motion.x = lerp(motion.x,0,0.01)
	motion = move_and_slide(motion,up)
	
	
func shootSpecialBullet():
	var shoot_bullet = specialbullet.instance()
	if $AnimatedSprite.flip_h:
		$Shoot.scale.x = -1
		shoot_bullet.get_child(0).flip_h = true
		shoot_bullet.velocity = -320
	else:
		$Shoot.scale.x = 1
		shoot_bullet.velocity = 320
		
	shoot_bullet.global_position = $Shoot/Direction.global_position
	get_tree().call_group("World2","add_child",shoot_bullet)
	
	
func shootBullet():
	var shoot_bullet = bullet.instance()
	if $AnimatedSprite.flip_h:
		$Shoot.scale.x = -1
		shoot_bullet.velocity = -320
	else:
		$Shoot.scale.x = 1
		shoot_bullet.velocity = 320
		
	shoot_bullet.global_position = $Shoot/Direction.global_position
	get_tree().call_group("World","add_child",shoot_bullet)


#Barra energia

var energia = 0
export var disminucion_energia = 50

func _ready():
	$TextureProgress/Timer.connect("timeout", self, "disminuir_energia")
	$TextureProgress/Timer.start(2)

func disminuir_energia():
	energia += disminucion_energia
	if energia > 100:
		energia = 100
	$TextureProgress.value = energia
	if energia == 100:
		highShoot = true

func sumar_energia():
	energia = $TextureProgress.value + 25
	$TextureProgress.value += 25

func restaurar_energia():
	energia = 0
	$TextureProgress.value = 0
func changeZoom(newZoom):
	$Camera2D.zoom*=1.5
