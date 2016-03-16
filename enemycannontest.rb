require "minitest/autorun"

require "gosu"
require "yaml"

require_relative "gamecontext"
require_relative "enemycannon"
require_relative "player"

class TestEnemyCannon < Minitest::Test

  def setup

    config = YAML.load_file("config.yml")
    window_attributes = {}
    window_attributes["width"] = config["width"]
    window_attributes["height"] = config["height"]
    @player = Player.new(name, config, window_attributes)
    @speed = 2
    @gamecontext = GameContext.new(@player, window_attributes, config, nil, nil, nil)
    
  end

  def test_calculate_angle()

    @player.x = 200
    @player.y = 200
    @cannon = EnemyCannon.new(@gamecontext, @speed, 400, 400)
    angle = @cannon.calculate_angle()
    assert_equal 90, angle 
  end
end