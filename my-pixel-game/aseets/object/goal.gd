extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	# 触れてきた相手（body）の名前が「Player」かどうかをチェックする
	if body.name == "Player":
		# 💡 ここに、後で「クリア画面に切り替えるコード」を足すわよ！
		# 文字を出す代わりに、クリア画面（clear.tscn）に切り替える！
		# get_tree().change_scene_to_file("res://aseets/clear/clear.tscn")
		get_tree().call_deferred("change_scene_to_file", "res://aseets/clear/clear.tscn")
