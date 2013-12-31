require 'spec_helper'

describe IncidentReport do

  before :each do
    Incident.stub(:all).and_return([
      Incident.new(101, :app, 'ServiceDown', :critical, :medium, Date.parse('2013-12-10')),
      Incident.new(102, :worker, 'DatabaseDown', :major, :medium, Date.parse('2013-12-10')),
      Incident.new(103, :app, 'DatabaseDown', :major, :medium, Date.parse('2013-12-11')),
      Incident.new(104, :app, 'ConnectionLost', :minor, :medium, Date.parse('2013-12-11')),
      Incident.new(105, :app, 'DatabaseDown', :major, :high, Date.parse('2013-12-12')),
      Incident.new(106, :app, 'ServiceDown', :critical, :medium, Date.parse('2013-12-16'))
    ])
  end

  it "should query by filters" do
    incidents = IncidentReport
                  .for(:app)
                  .severity(:critical, :major)
                  .priority(:high, :medium)
                  .from(Date.parse('2013-12-10'))
                  .to(Date.parse('2013-12-15'))
                  .retrieve_incidents

    incidents.collect(&:id).should == [ 101, 103, 105 ]
  end

end
