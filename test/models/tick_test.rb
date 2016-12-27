require 'test_helper'

class TickTest < ActiveSupport::TestCase
  setup do
    @t1 = Tick.new(number: 1, group: 1, source: 'test')
    @t1.save!
  end

  def setup_t2
    sleep 0.1
    @t2 = Tick.new(number: 2, group: 1, source: 'test')
    @t2.save!
  end

  test "dyno_time is updated" do
    setup_t2
    assert @t1.dyno_time < @t2.dyno_time
  end

  test "server_time is updated" do
    setup_t2
    assert @t1.server_time < @t2.server_time
  end

  test "uptime is updated" do
    setup_t2
    assert @t1.uptime < @t2.uptime
  end

  test "dyno_time is available in float" do
    assert @t1.dyno_time.to_f == @t1.dyno_time_float
  end

  test "dyno_time is available in string" do
    assert (@t1.dyno_time - Time.parse(@t1.dyno_time_str)).abs < 0.01
  end
end
