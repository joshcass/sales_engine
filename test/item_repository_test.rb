require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require_relative '../lib/item_repository.rb'

class ItemRepositoryTest < Minitest::Test
  def setup
    @test_item_repo = ItemRepository.new(SmarterCSV.process('./test_data/items.csv'), self)
  end

  def repo_for(*hashes)
    ItemRepository.new(hashes, self)
  end

  def test_all_method_returns_everything
    repo = repo_for({id: 1,},
                    {id: 4,},
                    {id: 5})
    assert_equal 3, repo.all.count
  end

  def test_random_method_returns_random_item
    assert @test_item_repo.all.include?(@test_item_repo.random)
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    repo = repo_for({id: 1, name: 'Centennial Glory'},
                    {id: 4, name: 'Book of Alexandria'})
    assert_equal "Centennial Glory",   repo.find_by_id(1).name
    assert_equal "Book of Alexandria", repo.find_by_id(4).name
    assert_equal nil,                  repo.find_by_id(2)
  end

  def test_find_by_name_returns_one_object_with_a_given_name
    repo = repo_for({id: 1, name: 'Centennial Glory'},
                    {id: 4, name: 'Book of Alexandria'})
    assert_equal 1,  repo.find_by_name('Centennial Glory').id
    assert_equal 4,  repo.find_by_name('Book of Alexandria').id
    assert_equal nil,repo.find_by_name('stinky socks').id
  end

  def test_find_by_description_returns_one_object_with_a_given_description
    repo = repo_for({id: 1, description: "the best item ever"},
                    {id: 4, description: "the worst item ever"})
    assert_equal 1,   repo.find_by_description("the best item ever").id
    assert_equal nil, repo.find_by_description("an average item").id
  end

  def test_find_by_unit_price_returns_one_object_with_that_price
    repo = repo_for({id: 1, unit_price: BigDecimal("1499.99")},
                    {id: 4, unit_price: BigDecimal("1.99")})
    assert_equal 1,   repo.find_by_unit_price(BigDecimal("1499.99")).id
    assert_equal nil, repo.find_by_unit_price(BigDecimal("12.00")).id
  end

  def test_find_by_merchant_id_returns_one_object_with_that_id
    repo = repo_for({id: 1, merchant_id: 12},
                    {id: 4, merchant_id: 5})
    assert_equal 1,   repo.find_by_merchant_id(12).id
    assert_equal nil, repo.find_by_merchant_id(99).id
  end

  def test_find_by_created_at_returns_one_object_created_then
    repo = repo_for({id: 1, created_at: Date.parse("Wed, 29 Apr 15")},
                    {id: 4, created_at: Date.parse("Tue, 28 Apr 15")})
    assert_equal 1,   repo.find_by_created_at(Date.parse("Wed, 29 Apr 15")).id
    assert_equal nil, repo.find_by_created_at(Date.parse("Mon, 27 Apr 15")).id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    repo = repo_for({id: 1, created_at: Date.parse("Wed, 29 Apr 15")},
                    {id: 4, created_at: Date.parse("Tue, 28 Apr 15")})
    assert_equal 5,   repo.find_by_updated_at(Date.parse("Wed, 29 Apr 15")).id
    assert_equal nil, repo.find_by_updated_at(Date.parse("Mon, 27 Apr 15")).id
  end

  def test_find_all_by_name_returns_array_of_all_objects_with_that_name
    repo = repo_for({name: "Swordbreaker"},
                    {name: "Oathbreaker"},
                    {name: "Swordbreaker")
    assert_equal [], repo.find_all_by_name("Pearl Pillar")
    assert_equal 2,  repo.find_all_by_name("Swordbreaker").length
  end

  def test_find_all_by_unit_price_returns_array_of_all_objects_with_that_price
    repo = repo_for({unit_price: BigDecimal("1499.99")},
                    {unit_price: BigDecimal("1.99")})
                    {unit_price: BigDecimal("1499.99")
    assert_equal [],repo.find_all_by_unit_price(0)
    assert_equal 2, repo.find_all_by_unit_price(BigDecimal("1499.99")).length
  end

  def test_find_all_by_description_returns_array_of_all_objects_with_that_description
    repo = repo_for({description: "the best item ever"},
                    {description: "the worst item ever"},
                    {description: "the best item ever"})
    assert_equal 2,   repo.find_all_by_description("the best item ever").length
    assert_equal nil, repo.find_all_by_description("an average item").length
  end

  def test_find_all_by_merchant_id_returns_array_of_all_objects_with_that_merchant_id
    repo = repo_for({id: 1, merchant_id: 12},
                    {id: 4, merchant_id: 5},
                    {id: 3, merchant_id: 12},)
    assert_equal 2,   repo.find_all_by_merchant_id(12).length
    assert_equal nil, repo.find_all_by_merchant_id(99).length
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    repo = repo_for({id: 1, created_at: Date.parse("Wed, 29 Apr 15")},
                    {id: 4, created_at: Date.parse("Tue, 28 Apr 15")},
                    {id: 3, created_at: Date.parse("Wed, 29 Apr 15"))
    assert_equal 1,   repo.find_by_created_at(Date.parse("Wed, 29 Apr 15")).id
    assert_equal nil, repo.find_by_created_at(Date.parse("Mon, 27 Apr 15")).id
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
