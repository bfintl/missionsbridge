require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe Account do
  fixtures :accounts

  describe 'being created' do
    before do
      @account = nil
      @creating_account = lambda do
        @account = create_account
        violated "#{@account.errors.full_messages.to_sentence}" if @account.new_record?
      end
    end
    
    it 'increments User#count' do
      @creating_account.should change(Account, :count).by(1)
    end
  end

  it 'requires login' do
    lambda do
      u = create_account(:login => nil)
      u.errors.on(:login).should_not be_nil
    end.should_not change(Account, :count)
  end

  it 'requires password' do
    lambda do
      u = create_account(:password => nil)
      u.errors.on(:password).should_not be_nil
    end.should_not change(Account, :count)
  end

  it 'requires password confirmation' do
    lambda do
      u = create_account(:password_confirmation => nil)
      u.errors.on(:password_confirmation).should_not be_nil
    end.should_not change(Account, :count)
  end

  it 'requires email' do
    lambda do
      u = create_account(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(Account, :count)
  end

  it 'resets password' do
    accounts(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    Account.authenticate('quentin', 'new password').should == accounts(:quentin)
  end

  it 'does not rehash password' do
    accounts(:quentin).update_attributes(:login => 'quentin2')
    Account.authenticate('quentin2', 'test').should == accounts(:quentin)
  end

  it 'authenticates account' do
    Account.authenticate('quentin', 'test').should == accounts(:quentin)
  end

  it 'sets remember token' do
    accounts(:quentin).remember_me
    accounts(:quentin).remember_token.should_not be_nil
    accounts(:quentin).remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    accounts(:quentin).remember_me
    accounts(:quentin).remember_token.should_not be_nil
    accounts(:quentin).forget_me
    accounts(:quentin).remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    accounts(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    accounts(:quentin).remember_token.should_not be_nil
    accounts(:quentin).remember_token_expires_at.should_not be_nil
    accounts(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    accounts(:quentin).remember_me_until time
    accounts(:quentin).remember_token.should_not be_nil
    accounts(:quentin).remember_token_expires_at.should_not be_nil
    accounts(:quentin).remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    accounts(:quentin).remember_me
    after = 2.weeks.from_now.utc
    accounts(:quentin).remember_token.should_not be_nil
    accounts(:quentin).remember_token_expires_at.should_not be_nil
    accounts(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

protected
  def create_account(options = {})
    record = Account.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.save
    record
  end
end
