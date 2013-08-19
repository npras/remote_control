class RemoteControl
  attr_reader :channels
  attr_accessor :current

  def initialize opts
    @channels = (opts[:low]..opts[:high]).to_a - opts[:blocked]
    @clicks = 0
    @current = channels.sample # picks random channel at startup
    @sequence = opts[:sequence]
  end

  def up
    current_index = channels.index current
    new_index = (current_index == channels.size-1) ? 0 : current_index+1
    self.current = channels[new_index]
  end

  def down
    current_index = channels.index current
    new_index = (current_index == 0) ? channels.size-1 : current_index-1
    self.current = channels[new_index]
  end

end

#rc = RemoteControl.new low: 1, high: 20, blocked: [2, 18, 19], seq: [15, 14, 17, 1, 17]
#p rc.available
#p rc.current
#p rc.up
#p rc.down

