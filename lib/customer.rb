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

  # def transactions
    # get all invoices for customer
    # get all transactions for invoice id
    #return transactions to caller
  # end

  # def favorite_merchant
    # find all invoices for customer id
    # find the merchant id that appears in the most invoices
    # return merchant to caller
  # end
end
