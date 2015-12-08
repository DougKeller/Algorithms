class Timer
  def self.start
    @start = @last = Time.now
  end

  def self.lap
  	temp = @last
  	@last = Time.now
  	format(@last - temp)
  end

  def self.elapsed
  	format(Time.now - @start)
  end

  def self.format(time)
  	time > 1 ? "#{time.round(2)}s" : "#{(time * 1000).ceil}ms"
  end
end

class Progress
  def initialize(size)
    @count = -1
    @prev = 0
    @size = size
    step
  end

  def step
    @count += 1
    bar = (@count * 51.0 / @size).floor
    percent = (@count * 100.0 / @size).floor
    pct = " #{percent}%"
    num = "#{@count}"
    den = "#{@size}"

    pct_str = pct + (' ' * (25 - num.length - pct.length)) + num + '/' + den + (' ' * (25 - den.length))

    output = pct_str[0 .. bar].colorize(background: :green) + (pct_str[bar + 1 .. 50] || '').colorize(background: :yellow)
    print "\r#{output}"
  end

  def conclude(message)
    output = (' ' + message + (' ' * (50 - message.length))).colorize(background: :green)
    print "\r#{output}\n"
  end
end