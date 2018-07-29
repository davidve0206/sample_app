require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", email: "user@test.com",
                     password: "password", password_confirmation: "password")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  #name validation
  
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  #email validation
  
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 250+ "@test.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email should be unique" do
    user_duplicate = @user.dup
    user_duplicate.email = @user.email.upcase
    @user.save
    assert_not user_duplicate.valid?
  end
  
  test "email should be saved as lower-case" do
    mixed_case_emal = "Foo@TeSt.cOm"
    @user.email = mixed_case_emal
    @user.save
    assert_equal mixed_case_emal.downcase, @user.reload.email
  end
  
  #password validation
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end
  
  test "password should be long enough" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
end
