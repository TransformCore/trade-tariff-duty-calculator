class UserSession
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def remove_keys_after(key)
    keys_to_remove = session.keys.map(&:to_i).uniq.select { |k| k > key }

    return if keys_to_remove.empty?

    session.delete(*keys_to_remove)
  end

  def import_date
    return unless session.key?(Wizard::Steps::ImportDate::STEP_ID)

    Date.parse(session[Wizard::Steps::ImportDate::STEP_ID])
  end

  def import_date=(value)
    session[Wizard::Steps::ImportDate::STEP_ID] = value
  end

  def import_destination
    session[Wizard::Steps::ImportDestination::STEP_ID]
  end

  def import_destination=(value)
    session[Wizard::Steps::ImportDestination::STEP_ID] = value
  end

  def country_of_origin
    session[Wizard::Steps::CountryOfOrigin::STEP_ID]
  end

  def country_of_origin=(value)
    session[Wizard::Steps::CountryOfOrigin::STEP_ID] = value
  end

  def ni_to_gb_route?
    import_destination == 'GB' && country_of_origin == 'XI'
  end

  def eu_to_ni_route?
    import_destination == 'XI' && Api::GeographicalArea.eu_member?(country_of_origin)
  end
end