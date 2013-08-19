require 'remote_control'

describe RemoteControl do

  before(:each) do
    @rc = RemoteControl.new low: 1, high: 20, blocked: [2, 18, 19], seq: [15, 14, 17, 1, 17]
  end

  it "should not list blocked channels" do
    @rc.channels.should_not include(2, 18, 19)
    @rc.channels.should include(1, 3, 5)
  end

  describe "#up" do
    it "should increment the current channel by one" do
      @rc.current = 3
      @rc.up
      @rc.current.should == 4
    end
    
    it "should skip blocked channels" do
      @rc.current = 1
      @rc.up
      @rc.current.should == 3
    end

    it "should cycle" do
      @rc.current = 20
      @rc.up
      @rc.current.should == 1
    end
  end

  describe "#down" do
    it "should decrement the current channel by one" do
      @rc.current = 5
      @rc.down
      @rc.current.should == 4
    end
    
    it "should skip blocked channels" do
      @rc.current = 20
      @rc.down
      @rc.current.should == 17
    end

    it "should cycle" do
      @rc.current = 1
      @rc.down
      @rc.current.should == 20
    end
  end

end