class Customer
  attr_reader :customer, :parent

  def initialize(customer, parent)
    @customer = customer
    @parent = parent
  end

  def id
    @customer[:id]
  end

  def first_name
    @customer[:first_name]
  end

  def last_name
    @customer[:last_name]
  end

  def created_at
    @customer[:created_at]
  end

  def updated_at
    @customer[:updated_at]
  end
end
