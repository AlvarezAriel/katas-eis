require_relative '../../app/models/Board.rb'

Given(/^a board with dimensions "([0-9]+)" x "([0-9]+)"$/) do |width, height|
  @board = Board.new width, height
end

Given(/^(?:I create )?a (large|small) ship in position "([0-9]+):([0-9]+)"$/) do |ship_type, x,y|
  @ship = Ship.send("#{ship_type}_at", x ,y)
  begin
    @board.add_ship @ship
  rescue => some_error
    @error = some_error
  end
end

Then(/^position "([0-9]+):([0-9]+)" is not empty$/) do |x,y|
  @board.is_water_at?(x,y).should be false
end

Given(/^I shoot to position "([0-9]+):([0-9]+)"$/) do |x,y|
  @shoot_position = [x,y]
  @board.shoot_at(x,y)
end

Then(/^I get hit$/) do
  @ship.is_hit?.should be true
end

Then(/^I get water$/) do
  @board.is_water_at?(@shoot_position[0], @shoot_position[1]).should be true
end

Then(/^I get sink$/) do
  @ship.is_sink?.should be true
end

Then(/^an error should be thrown$/) do
  @error.should_not be_nil
end

Transform /^(-?\d+)$/ do |number|
  number.to_i
end

