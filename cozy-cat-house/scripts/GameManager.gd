extends Node

# ── Настройки уровня ──────────────────────────────────────
const MOVES_START: int = 20       # Ходов на уровень
const SCORE_PER_GEM: int = 10     # Очков за одну уничтоженную фишку

# ── Текущее состояние ─────────────────────────────────────
var moves_left: int = MOVES_START
var score: int = 0
var is_game_over: bool = false

# ─────────────────────────────────────────────────────────
func _ready() -> void:
	# Подписываемся на сигнал с Board.gd
	EventBus.gems_matched.connect(_on_gems_matched)
	print("GameManager готов. Ходов: ", moves_left)

# Вызывается каждый раз, когда Board уничтожает фишки
func _on_gems_matched(count: int) -> void:
	if is_game_over:
		return

	# Начисляем очки
	score += count * SCORE_PER_GEM
	
	# Тратим ход
	moves_left -= 1
	
	print("Ход сделан! Фишек: ", count, " | Очки: ", score, " | Ходов осталось: ", moves_left)
	
	# Сообщаем всем что данные изменились
	EventBus.score_updated.emit(score)
	EventBus.moves_updated.emit(moves_left)
	
	# Проверяем конец игры
	if moves_left <= 0:
		_end_game()

func _end_game() -> void:
	is_game_over = true
	print("Игра окончена! Финальный счёт: ", score)
	EventBus.game_over.emit(score)
