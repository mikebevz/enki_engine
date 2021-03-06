Given /I am logged in/ do
  visit '/admin/session'
  check "Bypass credentials check"
  click_on "Login with OpenID"
end

Then /^the comment exists$/ do
  Comment.count.should == 2
end

Given /^the following comments? exists:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Factory(:comment, hash)
  end
end

Given /^a comment exists with attributes:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Comment.find(:first, :conditions => hash).should_not be_nil
  end
end

Given /^a comment does not exist with attributes:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Comment.find(:first, :conditions => hash).should be_nil
  end
end
