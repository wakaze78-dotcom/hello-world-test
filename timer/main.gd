extends Control

@onready var time_label = $HBoxContainer/TimeArea/VBoxContainer/TimeLabel
@onready var mode_button = $HBoxContainer/TimeArea/VBoxContainer/ModeButton
@onready var char_sprite = $HBoxContainer/CharArea/AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@onready var background = $Background

var current_mode = "CLOCK"
var timer_seconds = 40 # 25分（テスト用に 10 とかに書き換えてもOK！）
var is_time_up = false

func _ready():
	update_display()

func _on_timer_timeout():
	if current_mode == "CLOCK":
		update_display()
	elif current_mode == "TIMER" and not is_time_up:
		if timer_seconds > 0:
			timer_seconds -= 1
			update_display()
			
			# 💡 【演出】残り30秒以下になったら猛ダッシュ！
			if timer_seconds <= 30 and timer_seconds > 0:
				if char_sprite.animation != "run":
					char_sprite.play("run")
		else:
			# 💡 【演出】タイムアップ！
			is_time_up = true
			time_label.text = "TIME UP!"
			char_sprite.stop() # キャラをストップ（あるいは専用のアニメがあればそれをplay）
			anim_player.play("alert") # 画面ピカピカ点滅スタート！

func update_display():
	if current_mode == "CLOCK":
		var time = Time.get_time_dict_from_system()
		time_label.text = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	elif current_mode == "TIMER":
		var minutes = timer_seconds / 60
		var seconds = timer_seconds % 60
		time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_mode_button_pressed():
	if current_mode == "CLOCK":
		current_mode = "TIMER"
		mode_button.text = "TIMER"
	else:
		current_mode = "CLOCK"
		mode_button.text = "CLOCK"
		# 時計モードに戻るときは演出をリセットする
		is_time_up = false
		anim_player.stop()
		background.color = Color("#00ff00") # 緑に戻す
		char_sprite.play("idol")
		
	update_display()
