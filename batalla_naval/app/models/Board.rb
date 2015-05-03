class Board
  attr_reader :size
  def initialize(width,height)
    @size = [width,height]
    @ships = []
  end

  def add_ship(new_ship)
    raise 'Position out of board' unless  new_ship.positions.all? {|(px,py)| is_in_board?(px,py)}

    @ships.push(new_ship)
  end

  def is_in_board?(x,y) x >= 0 && y >= 0 && y < @size[1] && x < @size[0] end

  def is_water_at?(x,y) @ships.none? {|ship| ship.occupies?(x,y)} end

  def shoot_at(x,y)
    @ships.each {|ship|
      ship.on_shoot(x,y){ |section| section.hit }}
  end
end

# The specified Ship is two positions long and can only be
# vertically aligned.
class Ship

  def self.large_at(x,y)
    Ship.new([[x,y], [x,y+1]])
  end

  def self.small_at(x,y)
    Ship.new([[x,y]])
  end

  def positions; @positions end

  def initialize(positions)
    @positions = positions.collect { |pos| ShipBlock.new(pos)}
  end

  def on_shoot(x,y, &block)
    if self.occupies?(x,y)
      block.call(@positions.select { |pos| pos.is [x,y] }.first)
    end
  end

  def occupies?(x,y) @positions.any? { |pos| pos.is [x,y] } end

  def is_hit?; @positions.any? {|p| p.is_hit?} end

  def is_sink?; @positions.all? {|p| p.is_hit?} end

end

class ShipBlock
  def initialize(pos)
    @pos = pos
    @is_hit = false
  end

  def is(p);    @pos == p end
  def hit;      @is_hit = true end
  def is_hit?;  @is_hit end

  def method_missing(m, *args, &block); @pos.send(m, *args, &block) end
end