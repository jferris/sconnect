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

  describe "published.or.titled", :shared => true do
    it "should find a published, untitled post" do
      should include(Post.create!(:published => true,  :title => nil))
    end

    it "should find an unpublished, titled post" do
      should include(Post.create!(:published => false, :title => 'Title'))
    end

    it "should find a published, titled post" do
      should include(Post.create!(:published => true,  :title => 'Title'))
    end

    it "not should find an unpublished, untitled post" do
      should_not include(Post.create!(:published => false, :title => nil))
    end

    it "should use non-conditional options from .published.titled" do
      should include_scope_options_from(Post.published.titled)
    end
  end

  describe "from_today", :shared => true do
    it "not find a post published two days ago" do
      should_not include(Post.create!(:published  => true,
                                      :title      => 'Title',
                                      :created_at => 2.days.ago))
    end
  end

  describe ".published.or.titled" do
    subject { Post.published.or.titled }
    it_should_behave_like "published.or.titled"
    it { should be_chainable }
  end

  describe ".from_today.published.or.titled" do
    subject { Post.from_today.published.or.titled }

    it_should_behave_like "published.or.titled"
    it_should_behave_like "from_today"
    it { should be_chainable }
  end

  describe ".published.or.titled.from_today" do
    subject { Post.published.or.titled.from_today }

    it_should_behave_like "published.or.titled"
    it_should_behave_like "from_today"
    it { should be_chainable }
  end

  describe ".published.or.titled.or.from_today" do
    subject { Post.published.or.titled.or.from_today }

    it "should find a published, untitled post from today" do
      should include(Post.create!(:published => true,  :title => nil))
    end

    it "should find an unpublished, titled post from today" do
      should include(Post.create!(:published => false, :title => 'Title'))
    end

    it "should find a published, titled post from today" do
      should include(Post.create!(:published => true,  :title => 'Title'))
    end

    it "should find an unpublished, untitled post from today" do
      should include(Post.create!(:published => false, :title => nil))
    end

    it "not should find an unpublished, untitled post from two days ago" do
      should_not include(Post.create!(:published  => false,
                                      :title      => nil,
                                      :created_at => 2.days.ago))
    end

    it "should use non-conditional options from .published.titled" do
      should include_scope_options_from(Post.published.titled)
    end

    it { should be_chainable }
  end

  describe ".published.or {|posts| posts.titled.from_today }" do
    subject { Post.published.or {|posts| posts.titled.from_today } }

    it "should find a published, untitled post from two days ago" do
      should include(Post.create!(:published  => true,
                                  :title      => nil,
                                  :created_at => 2.days.ago))
    end

    it "should find an unpublished, titled post from today" do
      should include(Post.create!(:published => false, :title => 'Title'))
    end

    it "should not find an unpublished, untitled post from today" do
      should include(Post.create!(:published => false, :title => nil))
    end

    it "should not find a unpublished, titled post from two days ago" do
      should_not include(Post.create!(:published  => false,
                                      :title      => 'Title',
                                      :created_at => 2.days.ago))
    end

    it { should be_chainable }
  end

end
