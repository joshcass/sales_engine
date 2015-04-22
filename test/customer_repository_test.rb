require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require_relative '../lib/customer_repository.rb'

#Repo classes need these methods:
#"all": return all customers
#"random": return one random customer
#"find_by_x(match)": find one customer that has attribute x
#"find_all_by_x(match)": find all customers that have attribute x
#for the Customer repo, the attributes are:
#id, first_name, last_name, created_at, updated_at.
#Text attributes (name, desc) should be case-insensitive.

class CustomerRepositoryTest < Minitest::Test
  def setup
    @test_customer_repo = CustomerRepository.new(SmarterCSV.process('./test_data/customers.csv'), self)
  end

  def test_all_method_returns_everything
    assert_equal 20, @test_customer_repo.all.count
    assert @test_customer_repo.all.all? { |customer| customer.class == Customer }
  end

  def test_random_method_returns_something_in_the_repository
    assert @test_customer_repo.all.include?(@test_customer_repo.random)
  end

  def test_random_method_returns_different_things
    #assert... something?
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    assert_equal "Afton", @test_customer_repo.find_by_id(1).first_name
    assert_equal "Luther", @test_customer_repo.find_by_id(4).first_name
  end

  def test_find_by_first_name_returns_one_object_with_a_given_name
    assert_equal 7, @test_customer_repo.find_by_first_name("Julius").id
  end

  def test_find_by_last_name_returns_one_object_with_a_given_name
    assert_equal 3, @test_customer_repo.find_by_last_name("Hollister").id
  end

  def test_find_by_created_at_returns_one_object_created_then
    assert_equal 2, @test_customer_repo.find_by_created_at("2012-03-27 14:54:10 UTC").id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    assert_equal 1, @test_customer_repo.find_by_updated_at("2012-03-27 14:54:09 UTC").id
  end

  def test_find_all_by_id_returns_array_of_all_objects_with_that_id
    #Aren't those supposed to be unique, though?
    assert_equal [], @test_customer_repo.find_all_by_id(135581778)
    sample_result = @test_customer_repo.find_all_by_id(3)
    assert sample_result.class == Array
    assert sample_result.length == 1
    assert sample_result[0].class == Customer
    assert sample_result[0].id == 3
  end

  def test_find_all_by_first_name_returns_array_of_all_objects_with_that_name
    assert_equal [], @test_customer_repo.find_all_by_first_name("Soma")
    sample_result = @test_customer_repo.find_all_by_first_name("Jade")
    assert sample_result.class == Array
    assert sample_result.length == 3
    assert sample_result.all? { |customer| customer.class == Customer}
    assert sample_result.all? { |customer| customer.first_name == "Jade"}
  end

  def test_find_all_by_last_name_returns_array_of_all_objects_with_that_name
    assert_equal [], @test_customer_repo.find_all_by_last_name("Lowell")
    sample_result = @test_customer_repo.find_all_by_last_name("Sapphire")
    assert sample_result.class == Array
    assert sample_result.length == 2
    assert sample_result.all? { |customer| customer.class == Customer}
    assert sample_result.all? { |customer| customer.last_name == "Sapphire"}
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal [], @test_customer_repo.find_all_by_created_at("2075-04-21 14:53:59 UTC")
    sample_result = @test_customer_repo.find_all_by_created_at("2012-03-27 14:54:10 UTC")
    assert sample_result.class == Array
    assert sample_result.length == 6
    assert sample_result.all? { |customer| customer.class == Customer}
    assert sample_result.all? { |customer| customer.created_at == "2012-03-27 14:54:10 UTC"}
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal [], @test_customer_repo.find_all_by_updated_at("2075-04-21 14:53:59 UTC")
    sample_result = @test_customer_repo.find_all_by_updated_at("2012-03-27 14:54:14 UTC")
    assert sample_result.class == Array
    assert sample_result.length == 3
    assert sample_result.all? { |customer| customer.class == Customer}
    assert sample_result.all? { |customer| customer.created_at == "2012-03-27 14:54:14 UTC"}
  end
end
