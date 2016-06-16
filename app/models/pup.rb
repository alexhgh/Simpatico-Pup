class Pup < ActiveRecord::Base

  belongs_to :user
  belongs_to :breeder
  belongs_to :breed

  has_one :comment

  validates :pup_name, :presence => true
  validates :breeder_responsibility, :presence => true
  validates :overall_health, :presence => true
  validates :trainability, :presence => true
  validates :social_behavior, :presence => true
  validates :energy_level, :presence => true
  validates :simpatico_rating, :presence => true

  attr_accessible :pup_name, :user_id, :breeder_id, :breed_id, :breeder_responsibility, :overall_health,
                  :trainability, :social_behavior,:dog_behavior, :energy_level, :simpatico_rating, :kennel,
                  :hashtag_1, :hashtag_2, :hashtag_3


  before_destroy { |pup| pup.breeder ? pup.breeder.increment_deleted_reviews : nil }



  # assets

  def safe_hashtag_string
    [hashtag_1, hashtag_2, hashtag_3].select{|hashtag| hashtag}
  end



  # class methods
  def Pup.find_by_breed(breed_name)
    breed_id = Breed.where("name = ?", breed_name)
    Pup.where("breed_id = ?", breed_id)
  end

  def Pup.avg_ratings_by_breed(breed_name)
    pups_by_breed = Pup.find_by_breed(breed_name)
    results_hash = {:overall_health => 0, :trainability => 0, :social_behavior => 0,
                    :energy_level => 0, :simpatico_rating => 0}
    results_num = {:overall_health => 0, :trainability => 0, :social_behavior => 0,
                    :energy_level => 0, :simpatico_rating => 0}
    pups_by_breed.each do |pup|
      results_hash.each do |rating, value|
        unless pup.send(rating) == 0
          results_hash[rating] += pup.send(rating)
          results_num[rating] += 1
        end
      end
    end
    results_hash.each do |k,v|
      results_hash[k] = 1.0 * results_hash[k]/results_num[k] if results_num[k] > 0
    end
    results_hash
  end




end
