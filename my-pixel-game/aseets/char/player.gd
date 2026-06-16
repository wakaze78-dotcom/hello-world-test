extends CharacterBody2D

const SPEED = 100.0        # 移動速度（320x180なら100くらいが快適）
const JUMP_VELOCITY = -200.0 # ジャンプ力
var gravity = 800          # 重力の強さ

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# 重力の処理
	if not is_on_floor():
		velocity.y += gravity * delta

	# ジャンプの処理
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 左右の入力を取得
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		# 向きを反転
		animated_sprite.flip_h = direction < 0
		animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.stop() # 止まったらアニメ停止

	move_and_slide()
