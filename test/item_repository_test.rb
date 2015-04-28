require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require_relative '../lib/item_repository.rb'

class ItemRepositoryTest < Minitest::Test
  def setup
    @test_item_repo = ItemRepository.new(SmarterCSV.process('./test_data/items.csv'), self)
  end

  def test_all_method_returns_everything
    assert_equal 22, @test_item_repo.all.count
    assert @test_item_repo.all.all? { |item| item.class == Item }
  end

  def test_random_method_returns_random_item
    assert @test_item_repo.all.include?(@test_item_repo.random)
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    assert_equal "Centennial Glory", @test_item_repo.find_by_id(1).name
    assert_equal "Book of Alexandria", @test_item_repo.find_by_id(4).name
  end

  def test_find_by_name_returns_one_object_with_a_given_name
    assert_equal 2, @test_item_repo.find_by_name("Water Dragon Boots").id
    assert_equal 5, @test_item_repo.find_by_name("Swordbreaker").id
  end

  def test_find_by_description_returns_one_object_with_a_given_description
    assert_equal 2, @test_item_repo.find_by_description("Blue shoes worn by a fast-moving heroine. Not completely worn through somehow.").id
  end

  def test_find_by_unit_price_returns_one_object_with_that_price
    assert_equal 3, @test_item_repo.find_by_unit_price(BigDecimal("1499.99")).id
  end

  def test_find_by_merchant_id_returns_one_object_with_that_id
    assert_equal 1, @test_item_repo.find_by_merchant_id(1).id
  end

  def test_find_by_created_at_returns_one_object_created_then
    assert_equal 4, @test_item_repo.find_by_created_at("1970-01-01 00:00:00 UTC").id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    assert_equal 5, @test_item_repo.find_by_updated_at("2015-04-21 14:53:59 UTC").id
  end

  def test_find_all_by_id_returns_array_of_all_objects_with_that_id
    #Aren't those supposed to be unique, though?
    assert_equal [], @test_item_repo.find_all_by_id(135581778)
    sample_result = @test_item_repo.find_all_by_id(3)
    assert sample_result.class == Array
    assert sample_result.length == 1
    assert sample_result[0].class == Item
    assert sample_result[0].id == 3
  end

  def test_find_all_by_name_returns_array_of_all_objects_with_that_name
    assert_equal [], @test_item_repo.find_all_by_name("Pearl Pillar")
    sample_result = @test_item_repo.find_all_by_name("Swordbreaker")
    assert sample_result.class == Array
    assert_equal 2, sample_result.size
    assert sample_result[0].class == Item
    assert sample_result.all? {|item| "Swordbreaker" == item.name}
  end

  def test_find_all_by_unit_price_returns_array_of_all_objects_with_that_price
    assert_equal [], @test_item_repo.find_all_by_unit_price(0)
    sample_result = @test_item_repo.find_all_by_unit_price(BigDecimal("1500.0"))
    assert sample_result.class == Array
    assert_equal 1, sample_result.length
    assert sample_result[0].class == Item
    assert sample_result[0].unit_price == BigDecimal("1500.0")
  end

  def test_find_all_by_description_returns_array_of_all_objects_with_that_description
    #I sure *hope* those are unique, though
    assert_equal [], @test_item_repo.find_all_by_description("Apparently shovels come in weapon-grade quality; this one could be used pretty well as an axe.")
    sample_result = @test_item_repo.find_all_by_description("Legendary tome that could contain all the world's knowledge.")
    assert sample_result.class == Array
    assert_equal 1, sample_result.length
    assert sample_result[0].class == Item
    assert sample_result[0].description == "Legendary tome that could contain all the world's knowledge."
  end

  def test_find_all_by_merchant_id_returns_array_of_all_objects_with_that_merchant_id
    assert_equal [], @test_item_repo.find_all_by_merchant_id(5430987)
    sample_result = @test_item_repo.find_all_by_merchant_id(1)
    assert sample_result.class == Array
    assert_equal 2, sample_result.length
    assert sample_result.all? { |item| item.class == Item}
    assert sample_result.all? { |item| item.merchant_id == 1}
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal [], @test_item_repo.find_all_by_created_at("2075-04-21 14:53:59 UTC")
    sample_result = @test_item_repo.find_all_by_created_at("2015-04-21 14:53:59 UTC")
    assert sample_result.class == Array
    assert_equal 2, sample_result.length
    assert sample_result.all? { |item| item.class == Item}
    assert sample_result.all? { |item| item.created_at == "2015-04-21 14:53:59 UTC"}
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal [], @test_item_repo.find_all_by_updated_at("2075-04-21 14:53:59 UTC")
    sample_result = @test_item_repo.find_all_by_updated_at("2015-04-21 14:53:59 UTC")
    assert sample_result.class == Array
    assert_equal 2, sample_result.length
    assert sample_result.all? { |item| item.class == Item}
    assert sample_result.all? { |item| item.created_at == "2015-04-21 14:53:59 UTC"}
  end
end
