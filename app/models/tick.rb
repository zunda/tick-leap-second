class Tick < ActiveRecord::Base
  STRING_FORMAT = "%FT%T.%N"

  if File.readable?('/proc/uptime')
    def Tick.uptime
      File.read('/proc/uptime').to_f
    end
  else
    $stderr.puts "#{__FILE__}:#{__LINE__} /proc/uptime is not available. Will not record uptime."
    def Tick.uptime
      nil
    end
  end

  def initialize(*args)
    super
    self.uptime = Tick.uptime
    ts = Time.now.utc
    self.dyno_time = ts
    self.dyno_time_float = ts.to_f
    self.dyno_time_str = ts.strftime(STRING_FORMAT)
  end

  def to_s
    "#{source} #{group} #{number} #{dyno_time_str ? dyno_time_str : created_at.strftime(STRING_FORMAT)} #{server_time ? server_time.strftime(STRING_FORMAT) : 'nil'}"
  end
end
