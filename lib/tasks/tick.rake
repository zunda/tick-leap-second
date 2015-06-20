namespace :tick do
  def source(task)
   "#{ENV['DYNO'] || File.basename(__FILE__)}/#{task.name}"
  end

  def readable(tick)
    "#{tick.source} #{tick.group} #{tick.number} " +
    [:created_at, :server_time].map{|p|
      ts = tick.send(p)
      "#{p}:#{ts ? ts.strftime("%FT%T.%L") : 'nil'}"
    }.join(" ")
  end

  def in_window?(window, interval)
    d = Time.now.to_f % interval
    return (d <= window / 2) || (interval - d <= window /2)
  end

  desc "Record a single tick"
  task :single => :environment do |task|
    tick = Tick.new(number: 0, group: 0, source: source(task))
    tick.save
    tick.reload
    puts readable(tick)
  end

  desc "Record periodic ticks"
  task :repeat, [:interval, :repeat] => :environment do |task, args|
    interval = (args.interval || 1).to_f
    repeat = (args.repeat || 10).to_i
    repeat.times do |i|
      tick = Tick.new(number: i + 1, group: 0, source: source(task))
      tick.save
      tick.reload
      puts readable(tick)
      sleep interval
    end
  end

  desc "Record burst ticks"
  task :burst, [:burst_interval, :window, :window_interval] => :environment do |task, args|
    burst_interval = (args.burst_interval || 0.1).to_f
    window = (args.window || 4.1).to_f
    window_interval = (args.window_interval || 3600).to_f
    number = 0
    group = 0
    loop do
      if in_window?(window, window_interval)
        group += 1
        begin
          number +=1
          tick = Tick.new(number: number, group: group, source: source(task))
          tick.save
          tick.reload
          puts readable(tick)
          sleep burst_interval
        end while in_window?(window, window_interval)
      end
      sleep burst_interval * 2
    end
  end
end
