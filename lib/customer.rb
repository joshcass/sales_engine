class Customer
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    @data[:id]
  end

  def first_name
    @data[:first_name]
  end

  def last_name
    @data[:last_name]
  end

  def created_at
    @data[:created_at]
  end

  def updated_at
    @data[:updated_at]
  end
end