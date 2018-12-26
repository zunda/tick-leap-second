class Tick < ActiveRecord::Base
  STRING_FORMAT = "%FT%T.%NZ"

  if File.readable?('/proc/uptime')
    def Tick.uptime
      File.read('/proc/uptime').to_f
    end
  elsif not `sysctl kern.boottime`.scan(/sec = \d+, usec = \d+/).empty?
    def Tick.uptime
      sec, usec = `sysctl kern.boottime`.scan(/sec = (\d+), usec = (\d+)/)[0]
      Time.now - (sec.to_f + usec.to_f*1e-6)
    end
  else
    $stderr.puts "#{__FILE__}:#{__LINE__} /proc/uptime or sysctl kern.boottime is not available. Will not record uptime."
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
    "#{source} #{group} #{number} #{dyno_time_str ? dyno_time_str : created_at.strftime(STRING_FORMAT)} #{server_time ? server_time.strftime(STRING_FORMAT) : 'nil'} #{uptime}"
  end
end
