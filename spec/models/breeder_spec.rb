require 'spec_helper'

describe Breeder do
  describe "getting average rating of a breeder" do
    before :each do
      @breeder = FactoryGirl.create(:breeder)
      pups = 10.times.collect  { |i| FactoryGirl.create(:pup, :breeder_id => @breeder.id)}
      @breeder.pups.should == pups
    end
    it "should get the average ratings for each pup" do
      results_hash = {:overall_health => 1, :trainability => 1, :social_behavior => 1,
                      :energy_level => 1, :simpatico_rating => 1, :breeder_responsibility => 1}
      @breeder.pups.each do |pup|
        results_hash.each{|k,v| pup.should_receive(k).and_return(1)}
      end
      @breeder.avg_pup_rating.should == results_hash
    end
  end
  describe "find or create breeder by name nad location" do
    it "should not create new breeder" do
      breeder = FactoryGirl.create(:breeder, :name => "Mcgoo")
      Breeder.find_or_create("Mcgoo", "Berkeley", "CA").should == breeder
    end
    it "should create new breeder" do
      breeder = Breeder.find_or_create("Jmac", "Berkeley", "CA")
      Breeder.where(:name => "Jmac").first.should == breeder
    end
  end
  describe "find all matching breeders" do
    before :each do
      @breeders = (1..10).map { |i| FactoryGirl.create(:breeder) }
      @other_breeders = (1..5).map { |i| FactoryGirl.create(:breeder, :name => "Tedus") }
      @pups = (1..10).map {|i| FactoryGirl.create(:pup, :breeder_id => @breeders[i-1].id)}
    end
    describe "find by city, state, name" do
      it "should find all the breeders input into database" do
        Breeder.find_by_substring("Ted", "Berkeley", "CA").should == @breeders + @other_breeders
      end
      it "should only return 5 breeders input" do
        breeders = Breeder.find_by_substring("Ted", "Berkeley", "CA")
        breeders.each do |breeder|
          assert(@breeders.include?(breeder) || @other_breeders.include?(breeder), "Breeder not in those created")
        end
      end
      it "should only find the 'Teddy' breeders" do
        Breeder.find_by_substring("Teddy", "Berkeley", "CA").each do |breeder|
          assert(@breeders.include?(breeder), "Breeder not in the 'Teddy' breeders array")
        end
      end
    end
    describe "find by type of dog breed" do
      it "should find all breeders" do
        breeders_by_breed = Breeder.find_breeders_by_breed(@pups[0].breed_1, @pups[0].breed_2)
        @breeders.each {|breeder| assert(breeders_by_breed.include?(breeder), "Breeder by breed not found")}
      end
      it "should not find any breeders" do
        breeders_by_breed = Breeder.find_breeders_by_breed("NOT A REAL BREED", "None")
        breeders_by_breed.size.should == 0
      end
    end
    describe "find breeders by city, state, name, and breed" do
      it "should find all initial 10 breeders" do
        query = {
            :city => "Berkeley",
            :state => "CA",
            :name => "Ted",
            :breed_1 => @pups[0].breed_1,
            :breed_2 => @pups[0].breed_2
        }
        breeders_intersect = Breeder.intersect_by_substring_and_breed(query, limit = 5)
        breeders_intersect.each do |breeder|
          assert(@breeders.include?(breeder))
        end
        breeders_intersect.size.should == 5
      end
    end
  end

  describe "increment deleted reviews for breeder" do
    it "should increase by 1" do
      breeder = FactoryGirl.create(:breeder)
      initial = breeder.removed_reviews
      breeder.increment_deleted_reviews
      breeder.removed_reviews.should == (initial + 1)
    end
  end
end