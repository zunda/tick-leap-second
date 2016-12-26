namespace :tick do
  def source(task)
   "#{ENV['DYNO'] || File.basename(__FILE__)}/#{task.name}"
  end

  def in_window?(window, interval)
    d = Time.now.to_f % interval
    return (d <= window / 2) || (interval - d <= window /2)
  end

  def until_sigterm(interval)
    continuing = true
    Signal.trap('TERM') do
      $stderr.puts "Got a SIGTERM. Terminating..."
      continuing = false
    end
    while continuing do
      yield
      sleep interval if continuing
    end
  end

  def tick(number, group, task)
    t = Tick.new(number: number, group: group, source: source(task))
    t.save
    t.reload
    puts t
  end

  desc "Record a single tick"
  task :single => :environment do |task|
    tick(0, 0, task)
  end

  desc "Record periodic ticks"
  task :repeat, [:interval, :repeat] => :environment do |task, args|
    interval = (args.interval || 0.1).to_f
    repeat = (args.repeat || 10).to_i
    repeat.times do |i|
      tick(i + 1, 0, task)
      sleep interval
    end
  end

  desc "Record periodic ticks until SIGTERM"
  task :untilsigterm, [:interval, :repeat] => :environment do |task, args|
    interval = (args.interval || 0.1).to_f
    repeat = (args.repeat || 10).to_i
    i = 0
    until_sigterm(interval) do
      tick(i, 0, task)
      i += 1
    end
  end

  desc "Record burst ticks"
  task :burst, [:burst_interval, :window, :window_interval] => :environment do |task, args|
    burst_interval = (args.burst_interval || 0.1).to_f
    window = (args.window || 4.1).to_f
    window_interval = (args.window_interval || 3600).to_f
    group = 0
    until_sigterm(burst_interval * 2) do
      if in_window?(window, window_interval)
        group += 1
        number = 0
        begin
          number +=1
          tick(number, group, task)
          sleep burst_interval
        end while in_window?(window, window_interval)
      end
    end
  end
end
