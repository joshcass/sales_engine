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

  def items
    parent.find_all_items(id)
  end

  def invoices
    parent.find_all_invoices(id)
  end

  # def revenue
    # calls out to sales engine
    # looks up all invoices for merchant => method already exists
    # check each invoice against transactions and eliminate failed transactions
    # once we have invoices we look up the invoice items => method already exists
    # multiply quantity by price to get total for each invoice
    # add up all the totals for that merchant
    # return total_revenue to caller
  # end

  # def items_sold
    # calls out to sales engine
    # looks up all invoices for merchant => method already exists
    # check each invoice against transactions and eliminate failed transactions
    # once it has invoices it looks up invoice items => method already exists
    # takes quantity of items for each invoice
    # adds up total quantity for the merchant
    # return total_items_sold to caller
  # end
end
