require 'spec_helper'

describe "a model with several conditional named scopes and associations" do

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

  describe "chaining two conditional scopes together with or" do
    before do
      @published = Post.create!(:published => true,  :title => nil)
      @titled    = Post.create!(:published => false, :title => 'Title')
      @both      = Post.create!(:published => true,  :title => 'Title')
      @neither   = Post.create!(:published => false, :title => nil)

      @posts = Post.published.or.titled
    end

    it "should find a record from the first scope" do
      @posts.should include(@published)
    end

    it "should find a record from the second scope" do
      @posts.should include(@titled)
    end

    it "should find a record present in both scopes" do
      @posts.should include(@both)
    end

    it "not should find a record not present in either scope" do
      @posts.should_not include(@neither)
    end

    it "should return a chainable scope" do
      @posts.class.instance_methods.should include('proxy_scope')
    end

    it "should use non-conditional options from the first scope" do
      @posts.should include_scope_options_from(Post.published)
    end

    it "should use non-conditional options from the second scope" do
      @posts.should include_scope_options_from(Post.titled)
    end
  end
end
