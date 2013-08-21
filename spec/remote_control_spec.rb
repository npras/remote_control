require 'remote_control'

describe RemoteControl do

  before(:each) do
    @rc = RemoteControl.new low: 1, high: 20, blocked: [2, 18, 19], seq: [15, 14, 17, 1, 17]
  end

  it "should not list blocked channels" do
    @rc.channels.should_not include(2, 18, 19)
    @rc.channels.should include(1, 3, 5)
  end

  describe "#op(:next)" do
    it "should increment the current channel by one" do
      @rc.current = 3
      @rc.op :next
      @rc.current.should == 4
    end

    it "should skip blocked channels" do
      @rc.current = 1
      @rc.op :next
      @rc.current.should == 3
    end

    it "should cycle" do
      @rc.current = 20
      @rc.op :next
      @rc.current.should == 1
    end
  end

  describe "#op(:prev)" do
    it "should decrement the current channel by one" do
      @rc.current = 5
      @rc.op :prev
      @rc.current.should == 4
    end

    it "should skip blocked channels" do
      @rc.current = 20
      @rc.op :prev
      @rc.current.should == 17
    end

    it "should cycle" do
      @rc.current = 1
      @rc.op :prev
      @rc.current.should == 20
    end
  end

  describe "#back" do
    it "should go back to the previous channel" do
      @rc.current = 100
      @rc.current = 200
      @rc.back
      @rc.current.should == 100
    end
  end

  describe "#goto" do
    it "should go straight to a given channel" do
      @rc.current = 100
      @rc.goto 177
      @rc.current.should == 177
    end

    it "should work with the 'back','next', and 'prev' buttons" do
      @rc.current = 1
      @rc.goto 12 #12
      @rc.op :next #13
      @rc.op :prev #12
      @rc.op :prev #11
      @rc.back     #12
      @rc.current.should == 12
    end
  end

  describe "#clicks" do
    it "should be zero initially" do
      @rc.clicks.should be_zero
    end

    it "should work for 'back', 'next, and 'prev' buttons" do
      @rc.current = 12
      @rc.op :next
      @rc.op :prev
      @rc.op :next
      @rc.op :next
      @rc.back
      @rc.clicks.should == 5
    end

    it "should work 'correctly' for '#goto' button" do
      @rc.current = 1
      @rc.goto 12   # 2 clicks
      @rc.goto 114  # 3 clicks
      @rc.goto 2    # 1 click
      @rc.goto 1154 # 4 clicks
      @rc.clicks.should == 10
    end
  end

  describe "#min_clicks" do
    it "should work as expected" do
      @rc.min_clicks.should == 8
    end
  end

end
