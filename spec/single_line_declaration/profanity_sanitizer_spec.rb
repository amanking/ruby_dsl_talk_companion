require 'spec_helper'

describe ProfanitySanitizer do
  before :each do
    Object.instance_eval { remove_const(:Post) if const_defined?(:Post) }

    Post = Struct.new(:title, :description, :author) do
      include ProfanitySanitizer
      sanitize_profanity_in :title, :description
    end
  end

  it "should sanitize swear words in title" do
    post = Post.new("darn it", "sorry, just testing!", "tester")
    post.title.should == "**** it"
    post.title_without_sanitization.should == "darn it"
  end

  it "should sanitize swear words in description" do
    post = Post.new("test title", "sorry, darn testing!", "tester")
    post.description.should == "sorry, **** testing!"
    post.description_without_sanitization.should == "sorry, darn testing!"
  end

  it "should not sanitize words author" do
    post = Post.new("test title", "test description", "darn")
    post.author.should == "darn"
    post.should_not respond_to(:author_without_sanitization)
  end

  it "should list attributes which have profanity" do
    post1 = Post.new("darn it", "sorry, just testing!", "tester")
    post1.profane_attributes.should == [:title]

    post2 = Post.new("darn it", "sorry, darn testing!", "tester")
    post2.profane_attributes.should == [:title, :description]
  end
end