require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions,
              :sales_engine,
              :id,
              :invoice_id,
              :result,
              :created_at

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

  def initialize(transaction_hashes, sales_engine)
    @transactions = parse_transactions(transaction_hashes, self)
    @sales_engine = sales_engine
  end

  def build_hash_tables
    @id = transactions.group_by{ |transaction| transaction.id }
    @invoice_id = transactions.group_by{ |transaction| transaction.invoice_id }
    @result = transactions.group_by{ |transaction| transaction.result }
    @created_at = transactions.group_by{ |transaction| transaction.created_at }
  end

  def all
    transactions
  end

  def random
    transactions.sample
  end

  def find_by_id(search_id)
    id[search_id].first
  end

  def find_by_invoice_id(search_id)
    invoice_id[search_id].first
  end

  def find_by_credit_card_number(search_cc_number)
    transactions.detect do |transaction|
      transaction.credit_card_number == search_cc_number
    end
  end

  def find_by_credit_card_expiration_date(search_cc_expiry_date)
    transactions.detect do |transaction|
      transaction.credit_card_expiration_date == search_cc_expiry_date
    end
  end

  def find_by_result(search_result)
    result[search_result].first
  end

  def find_by_created_at(search_created)
    created_at[search_created].first
  end

  def find_by_updated_at(search_updated)
    transactions.detect do |transaction|
      transaction.updated_at == search_updated
    end
  end

  def find_all_by_invoice_id(search_id)
    invoice_id[search_id]
  end

  def find_all_by_credit_card_number(search_cc_number)
    transactions.select do |transaction|
      transaction.credit_card_number == search_cc_number
    end
  end

  def find_all_by_credit_card_expiration_date(search_cc_expiry_date)
    transactions.select do |transaction|
      transaction.credit_card_expiration_date == search_cc_expiry_date
    end
  end

  def find_all_by_result(search_result)
    result[search_result]
  end

  def find_all_by_created_at(search_created)
    created_at[search_created]
  end

  def find_all_by_updated_at(search_updated)
    transactions.select do |transaction|
      transaction.updated_at == search_updated
    end
  end

  def find_invoice(invoice_id)
    sales_engine.find_invoice_by_id(invoice_id)
  end

  def new_transaction(invoice_id, cc_info)
    new_id = id.max_by { |k, v| k }.first + 1
    transactions << Transaction.new({id: new_id,
        invoice_id: invoice_id,
        credit_card_number: cc_info[:credit_card_number],
        credit_card_expiration_date: cc_info[:credit_card_expiration_date],
        result: cc_info[:result],
        created_at: Time.now.to_date,
        updated_at: Time.now.to_date}, self)
    build_hash_tables
    find_by_id(new_id)
  end

  private
  def parse_transactions(transaction_hashes, repo)
    transaction_hashes.map do |attributes_hash|
      Transaction.new(attributes_hash, repo)
    end
  end
end
