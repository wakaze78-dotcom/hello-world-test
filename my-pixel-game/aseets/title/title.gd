extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
# Main（ステージ）のシーンに画面を切り替える
	get_tree().change_scene_to_file("res://aseets/map/main.tscn") 
	# ※ もしステージのシーン名が「main.tscn」じゃない場合は、自分のファイル名に合わせてね！
