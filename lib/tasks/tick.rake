namespace :tick do
  def source(task)
   "#{ENV['DYNO'] || File.basename(__FILE__)}/#{task.name}"
  end

  def readable(tick)
    "#{tick.source}:#{tick.number} " +
    [:created_at, :server_time].map{|p|
      ts = tick.send(p)
      "#{p}:#{ts ? ts.strftime("%FT%T.%L") : 'nil'}"
    }.join(" ")
  end

  desc "Record a single tick"
  task :single => :environment do |task|
    tick = Tick.new(number: 0, source: source(task))
    tick.save
    tick.reload
    puts readable(tick)
  end

  desc "Record periodic ticks"
  task :periodic, [:interval] => :environment do |task, args|
    interval = args.interval.to_f || 10
    number = 0
    loop do
      number +=1 
      tick = Tick.new(number: number, source: source(task))
      tick.save
      tick.reload
      puts readable(tick)
      sleep interval
    end
  end
end
