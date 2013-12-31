require 'spec_helper'

describe SocialGraph do
  before :each do
    @fan_klass = Struct.new(:name) do
      include SocialGraph
      social_graph do
        relationship :fan_followings, as: :fan, to: :celebrity, is: :outgoing
      end
    end

    @celebrity_klass = Struct.new(:name) do
      include SocialGraph
      social_graph do
        relationship :fan_followings, as: :celebrity, to: :fan, is: :incoming
      end
    end
  end

  describe "fan followings" do
    it "should relate fans and celebrities from fan end" do
      husain = @fan_klass.new("M.F. Husain")
      madhuri = @celebrity_klass.new("Madhuri Dixit")

      husain.add_celebrity(madhuri)

      husain.celebrity_list.should == [ madhuri ]
      madhuri.fan_list.should == [ husain ]

      husain.fan_followings.should == [
        { relationship: :fan_followings, from_fan: husain, to_celebrity: madhuri }
      ]
      madhuri.fan_followings.should == [
        { relationship: :fan_followings, from_fan: husain, to_celebrity: madhuri }
      ]
    end

    it "should relate fans and celebrities from celebrity end" do
      husain = @fan_klass.new("M.F. Husain")
      madhuri = @celebrity_klass.new("Madhuri Dixit")

      madhuri.add_fan(husain)

      husain.celebrity_list.should == [ madhuri ]
      madhuri.fan_list.should == [ husain ]

      husain.fan_followings.should == [
        { relationship: :fan_followings, from_fan: husain, to_celebrity: madhuri }
      ]
      madhuri.fan_followings.should == [
        { relationship: :fan_followings, from_fan: husain, to_celebrity: madhuri }
      ]
    end
  end

end
