namespace :tick do
  def source(task)
   "#{ENV['DYNO'] || File.basename(__FILE__)}/#{task.name}"
  end

  desc "Record a single tick"
  task :single => :environment do |task|
    tick = Tick.create(number: 0, source: source(task))
    tick.save
    tick.reload
    puts tick.inspect
  end

  desc "Record periodic ticks"
  task :periodic, [:interval] => :environment do |task, args|
    interval = args.interval.to_f || 10
    puts interval
    number = 0
    loop do
      number +=1 
      tick = Tick.create(number: number, source: source(task))
      tick.save
      tick.reload
      puts tick.inspect
      sleep interval
    end
  end
end
