class RemoteControl
  attr_reader :channels
  attr_accessor :current, :previous

  def initialize opts
    @channels = (opts[:low]..opts[:high]).to_a - opts[:blocked]
    @clicks = 0
    @current = channels.sample # picks random channel at startup
    @sequence = opts[:sequence]
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
  end

  def back
    self.current = previous
  end

  def current= value
    self.previous = current
    @current = value
  end

end
