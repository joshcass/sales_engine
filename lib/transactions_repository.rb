require 'smarter_csv'
require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions

  def initialize(file)
    @transactions = parse_transactions(SmarterCSV.process(file))
  end

  def all
    transactions
  end

  def random
    transactions.sample
  end

  def find_by_id(id)
    transactions.detect do |transaction|
      transaction.id == id
    end
  end

  def find_by_invoice_id(invoice_id)
    transactions.detect do |transaction|
      transaction.invoice_id == invoice_id
    end
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
    transactions.detect do |transaction|
      transaction.result == result
    end
  end

  def find_by_created_at(created)
    transactions.detect do |transaction|
      transaction.created_at == created
    end
  end

  def find_by_updated_at(updated)
    transactions.detect do |transaction|
      transaction.updated_at == updated
    end
  end

  def find_all_by_id(id)
    transactions.select do |transaction|
      transaction.id == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    transactions.select do |transaction|
      transaction.invoice_id == invoice_id
    end
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
    transactions.select do |transaction|
      transaction.result == result
    end
  end

  def find_all_by_created_at(created)
    transactions.select do |transaction|
      transaction.created_at == created
    end
  end

  def find_all_by_updated_at(updated)
    transactions.select do |transaction|
      transaction.updated_at == updated
    end
  end

  private
  def parse_transactions(csv_data)
    csv_data.map do |transaction|
      Transaction.new(transaction)
    end
  end
end
