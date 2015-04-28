require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions, :sales_engine

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

  def initialize(csv_data, sales_engine)
    @transactions = parse_transactions(csv_data, self)
    @sales_engine = sales_engine
  end

  def all
    transactions
  end

  def random
    transactions.sample
  end

  def find_by_id(id)
    transactions.detect { |transaction| transaction.id == id }
  end

  def find_by_invoice_id(invoice_id)
    transactions.detect { |transaction| transaction.invoice_id == invoice_id }
  end

  def find_by_credit_card_number(credit_card_number)
    transactions.detect do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_by_credit_card_expiration_date(credit_card_expiration_date)
    transactions.detect do |transaction|
      transaction.credit_card_expiration_date == credit_card_expiration_date
    end
  end

  def find_by_result(result)
    transactions.detect { |transaction| transaction.result == result }
  end

  def find_by_created_at(created)
    transactions.detect { |transaction| transaction.created_at == created }
  end

  def find_by_updated_at(updated)
    transactions.detect { |transaction| transaction.updated_at == updated }
  end

  def find_all_by_id(id)
    transactions.select { |transaction| transaction.id == id }
  end

  def find_all_by_invoice_id(invoice_id)
    transactions.select { |transaction| transaction.invoice_id == invoice_id }
  end

  def find_all_by_credit_card_number(credit_card_number)
    transactions.select do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_credit_card_expiration_date(credit_card_expiration_date)
    transactions.select do |transaction|
      transaction.credit_card_expiration_date == credit_card_expiration_date
    end
  end

  def find_all_by_result(result)
    transactions.select { |transaction| transaction.result == result }
  end

  def find_all_by_created_at(created)
    transactions.select { |transaction| transaction.created_at == created }
  end

  def find_all_by_updated_at(updated)
    transactions.select { |transaction| transaction.updated_at == updated }
  end

  def find_invoice(invoice_id)
    sales_engine.find_invoice_by_id(invoice_id)
  end

  def transactions_failed?(invoice_id)
    find_all_by_invoice_id(invoice_id).all? do |transaction|
      transaction.result == "failed"
    end
  end

  def new_transaction(invoice_id, cc_info)
    new_id = transactions.max_by { |transaction| transaction.id }.id + 1
    transactions << Transaction.new({id: new_id,
        invoice_id: invoice_id,
        credit_card_number: cc_info[:credit_card_number],
        credit_card_expiration_date: cc_info[:credit_card_expiration_date],
        result: cc_info[:result],
        created_at: "#{Time.now.utc}",
        updated_at: "#{Time.now.utc}"}, self)
    find_by_id(new_id)
  end

  private
  def parse_transactions(csv_data, repo)
    csv_data.map { |transaction| Transaction.new(transaction, repo) }
  end
end
