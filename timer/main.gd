extends Control

# 子ノードへの参照（💡LayoutGroupを挟んだ正しい最新のパスに一括修正したわ！）
@onready var time_label = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/TimeGroup/TimeLabel
@onready var date_label = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/DataLabel
@onready var mode_button = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/ModeButton
@onready var char_sprite = $HBoxContainer/CharArea/CharLayoutGroup/AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@onready var stop_particles = $HBoxContainer/CharArea/CharLayoutGroup/StopParticles
@onready var background = $Background
@onready var sub_button = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/TimeGroup/SubButton
@onready var add_button = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/TimeGroup/AddButton

# コントロールボタン
@onready var start_stop_button = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/StartStopButton
@onready var reset_button = $HBoxContainer/TimeArea/LayoutGroup/VBoxContainer/ResetButton

var current_mode = "CLOCK"
var default_timer_seconds = 300 
var timer_seconds = 300
var INITIAL_SECONDS = 300
var is_timer_running = false     
var is_time_up = false

# インスペクターで設定した「元々のフォントサイズ」を記憶する変数
var base_font_size = 24

func _ready():
	sub_button.pressed.connect(_on_sub_button_pressed)
	add_button.pressed.connect(_on_add_button_pressed)
	start_stop_button.pressed.connect(_on_start_stop_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	
	base_font_size = time_label.get_theme_font_size("font_size")
	
	go_to_initial_screen()

# 初期画面（時計モード・初期状態）に戻す関数
func go_to_initial_screen():
	current_mode = "CLOCK"
	is_timer_running = false
	is_time_up = false
	timer_seconds = default_timer_seconds
	
	mode_button.text = "TO TIMER →"
	anim_player.stop()
	background.color = Color("#00ff00") 
	char_sprite.play("idol") 
	update_display()

func _on_timer_timeout():
	if current_mode == "CLOCK":
		update_display()
	elif current_mode == "TIMER" and is_timer_running and not is_time_up:
		if timer_seconds > 0:
			timer_seconds -= 1
			update_display()
			
			if timer_seconds <= 30 and timer_seconds > 0:
				if char_sprite.animation != "run":
					char_sprite.play("run")
		else:
			is_time_up = true
			is_timer_running = false
			time_label.text = "TIME UP!"
			start_stop_button.text = "START"
			char_sprite.stop()
			anim_player.play("alert")
			# 💡【演出追加】タイムアップ時に盛大に粒子を散らす！
			stop_particles.restart()
			update_display() 

# 画面表示の更新
func update_display():
	if current_mode == "CLOCK":
		var time = Time.get_time_dict_from_system()
		var date = Time.get_date_dict_from_system()
		
		time_label.text = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
		date_label.text = "%04d/%02d/%02d" % [date.year, date.month, date.day]
		date_label.show() 
		
		var big_size = int(base_font_size * 1.4)
		time_label.add_theme_font_size_override("font_size", big_size)
		
		# 💡時計の時は、文字が縦の空きスペースを使い切って上下中央にど真ん中配置されるようにする
		time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		time_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		sub_button.hide()
		add_button.hide()
		start_stop_button.hide()
		reset_button.hide()
		
	elif current_mode == "TIMER":
		date_label.hide()
		
		if not is_time_up:
			var minutes = timer_seconds / 60 
			var seconds = timer_seconds % 60
			time_label.text = "%02d:%02d" % [minutes, seconds]
		
		time_label.add_theme_font_size_override("font_size", base_font_size)
		
		# 💡タイマーの時は、縦に広がる力を消して元の正しい位置（横一列のボタンの間）に収める
		time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		time_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		if not is_timer_running:
			sub_button.show()
			add_button.show()
		else:
			sub_button.hide()
			add_button.hide()
			
		start_stop_button.show()
		reset_button.show()

# モード切り替え（CLOCK ⇄ TIMER）
func _on_mode_button_pressed():
	if current_mode == "CLOCK":
		current_mode = "TIMER"
		mode_button.text = "TO CLOCK →"
	else:
		current_mode = "CLOCK"
		mode_button.text = "TO TIMER →"
	update_display()

# スタート / ストップ
func _on_start_stop_button_pressed():
	if current_mode != "TIMER": return
	if is_time_up:
		_on_reset_button_pressed()
	
	is_timer_running = !is_timer_running
	
	if is_timer_running:
		start_stop_button.text = "STOP"
		char_sprite.play("run") 
	else:
		start_stop_button.text = "START"
		char_sprite.play("idol") 
		# 💡【テスト】ここにこの1行を足して、ゲームを実行してストップを押してみて！
		print("ストップボタンが押されたからパーティクルを出すよ！")
		# 💡【演出追加】パーティクルを爆発させる！
		# 👇【修正】パーティクルの位置を、キャラクターの位置と完全に同期させる！
		stop_particles.position = char_sprite.position
		stop_particles.restart()
		
	update_display()

# リセット
func _on_reset_button_pressed():
	is_timer_running = false
	is_time_up = false
	
	default_timer_seconds = INITIAL_SECONDS
	timer_seconds = default_timer_seconds 
	
	start_stop_button.text = "START"
	anim_player.stop()
	background.color = Color("#00ff00")
	char_sprite.play("idol")
	update_display()

# ＋ボタン
func _on_add_button_pressed():
	if current_mode == "TIMER" and not is_timer_running:
		if is_time_up:
			is_time_up = false
			anim_player.stop()
			background.color = Color("#00ff00")
			char_sprite.play("idol")
		
		timer_seconds += 30
		default_timer_seconds = timer_seconds 
		update_display()

# ーボタン
func _on_sub_button_pressed():
	if current_mode == "TIMER" and not is_timer_running:
		if is_time_up:
			is_time_up = false
			anim_player.stop()
			background.color = Color("#00ff00")
			char_sprite.play("idol")
			
		if timer_seconds > 30:
			timer_seconds -= 30
		else:
			timer_seconds = 0
			
		default_timer_seconds = timer_seconds 
		update_display()
