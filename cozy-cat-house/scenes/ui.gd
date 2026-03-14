extends CanvasLayer

@onready var label_moves: Label = $VBox/LabelMoves
@onready var label_score: Label = $VBox/LabelScore

func _ready():
	label_moves.text = "Ходы: 20"
	label_score.text = "Очки: 0"
	EventBus.moves_updated.connect(_on_moves_updated)
	EventBus.score_updated.connect(_on_score_updated)

func _on_moves_updated(value):
	label_moves.text = "Ходы: " + str(value)

func _on_score_updated(value):
	label_score.text = "Очки: " + str(value)
