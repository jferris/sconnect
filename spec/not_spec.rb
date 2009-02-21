require 'spec_helper'

describe "Post" do

  include ModelBuilder

  before do
    define_model :user
    define_model :category
    define_model :post, :published   => :boolean,
                        :title       => :string,
                        :user_id     => :integer,
                        :category_id => :integer do
      belongs_to :user
      belongs_to :category
      named_scope :published, :conditions => { :published => true },
                              :include    => :user
      named_scope :titled, :conditions => "title IS NOT NULL",
                           :include    => :category
      named_scope :from_today, lambda {
        { :conditions => ['created_at >= ?', 1.day.ago] }
      }
    end
  end

  describe "titled but not published", :shared => true do
    it "should find an unpublished, titled post" do
      should include(Post.create!(:published => false, :title => 'Title'))
    end

    it "should not find an unpublished, titled post" do
      should_not include(Post.create!(:published => true, :title => 'Title'))
    end

    it "should not find an published, untitled post" do
      should_not include(Post.create!(:published => true, :title => nil))
    end
  end

  describe ".not.published" do
    subject { Post.not.published }

    it "should find an unpublished post" do
      should include(Post.create!(:published => false))
    end

    it "should not find an unpublished post" do
      should_not include(Post.create!(:published => true))
    end

    it { should be_chainable }
  end

  describe ".not.published.titled" do
    subject { Post.not.published }
    it_should_behave_like "titled but not published"
    it { should be_chainable }
  end

  describe ".titled.not.published" do
    subject { Post.not.published }
    it_should_behave_like "titled but not published"
    it { should be_chainable }
  end
end

