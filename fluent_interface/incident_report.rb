Incident = Struct.new(:id, :system, :type, :severity, :priority, :date)

class IncidentReport
  def self.for(*systems)
    new(*systems)
  end

  def initialize(*systems)
    @systems = systems
  end

  def severity(*severity_levels)
    @severity_levels = severity_levels
    self
  end

  def priority(*priority_levels)
    @priority_levels = priority_levels
    self
  end

  def from(date)
    @from = date
    self
  end

  def to(date)
    @to = date
    self
  end

  def retrieve_incidents
    Incident.all.select do |incident|
      system_match?(incident) &&
      severity_match?(incident) &&
      priority_match?(incident) &&
      from_match?(incident) &&
      to_match?(incident)
    end
  end

  private

  def system_match?(incident)
    @systems.nil? || @systems.include?(incident.system)
  end

  def severity_match?(incident)
    @severity_levels.nil? || @severity_levels.include?(incident.severity)
  end

  def priority_match?(incident)
    @priority_levels.nil? || @priority_levels.include?(incident.priority)
  end

  def from_match?(incident)
    @from.nil? || @from <= incident.date
  end

  def to_match?(incident)
    @to.nil? || @to >= incident.date
  end

end