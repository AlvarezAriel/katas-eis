class Board
  attr_reader :size
  def initialize(width,height)
    @size = [width,height]
    @ships = []
  end

  def add_ship_at(x,y)
    new_ship = Ship.new(x,y)

    raise 'Position out of board' unless  new_ship.positions.all? {|(px,py)| is_in_board?(px,py)}

    @ships.push(Ship.new(x,y))
  end

  def is_in_board?(x,y) x >= 0 && y >= 0 && y < @size[1] && x < @size[0] end

  def is_water_at?(x,y) @ships.none? {|ship| ship.occupies?(x,y)} end

end

# The specified Ship is two positions long and can only be
# vertically aligned.
class Ship

  def positions; @positions end

  def initialize(from_x,from_y) @positions = [ [from_x,from_y], [from_x,from_y+1] ] end

  def occupies?(x,y) @positions.any? { |pos| pos == [x,y] } end

end