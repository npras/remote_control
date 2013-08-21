class RemoteControl
  attr_reader :channels, :clicks, :previous, :sequence
  attr_accessor :current

  def initialize opts
    @channels = (opts[:low]..opts[:high]).to_a - opts[:blocked]
    @clicks = 0
    @current = channels.first # picks first non-blocked channel at startup
    @sequence = opts[:sequence]
  end

  def min_clicks
    sequence.each_with_index do |e, i|
      next if e == current and i == 0
    end
  end

  def op action
    current_index = channels.index current
    new_index = case action
    when :next
      (current_index == channels.size-1) ? 0 : current_index+1
    when :prev
      (current_index == 0) ? channels.size-1 : current_index-1
    end
    self.current = channels[new_index]
    incr_clicks
  end

  def back
    self.current = previous
    incr_clicks
  end

  def current= value
    @previous = current
    @current = value
  end

  def goto value
    incr_clicks value.to_s.size
    self.current = value
  end

  private
  def incr_clicks count = 1
    @clicks += count
  end

end

