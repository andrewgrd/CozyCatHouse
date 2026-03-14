extends Node

signal move_made()
signal moves_changed(moves_left: int)
signal score_changed(score: int)
signal level_won()
signal level_lost()
signal match_found(count: int)
signal cat_ability_used(cat_id: String)
signal blocker_removed(cell: Vector2i)
# Сигналы GameManager
signal gems_matched(count: int)    # Board отправляет → GameManager принимает
signal score_updated(new_score: int)
signal moves_updated(moves_left: int)
signal game_over(final_score: int)
