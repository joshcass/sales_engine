class Merchant
  attr_reader :merchant, :parent

  def initialize(merchant, parent)
    @merchant = merchant
    @parent = parent
  end

  def id
    merchant[:id]
  end

  def name
    merchant[:name]
  end

  def created_at
    merchant[:created_at]
  end

  def updated_at
    merchant[:updated_at]
  end
end
