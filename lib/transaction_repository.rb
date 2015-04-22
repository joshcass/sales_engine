require 'smarter_csv'
require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions, :parent

  def initialize(csv_data, parent)
    @transactions = parse_transactions(csv_data, self)
    @parent = parent
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
    transactions.detect { |transaction| transaction.credit_card_number == credit_card_number }
  end

  def find_by_credit_card_expiration_date(credit_card_expiration_date)
    transactions.detect { |transaction| transaction.credit_card_expiration_date == credit_card_expiration_date }
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
    transactions.select { |transaction| transaction.credit_card_number == credit_card_number }
  end

  def find_all_by_credit_card_expiration_date(credit_card_expiration_date)
    transactions.select { |transaction| transaction.credit_card_expiration_date == credit_card_expiration_date }
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

  private
  def parse_transactions(csv_data, repo)
    csv_data.map { |transaction| Transaction.new(transaction, repo) }
  end
end
