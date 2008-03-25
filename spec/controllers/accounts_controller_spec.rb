require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe AccountsController do
  fixtures :accounts

  it 'allows signup' do
    lambda do
      create_account
      response.should be_redirect
    end.should change(Account, :count).by(1)
  end

  

  

  it 'requires login on signup' do
    lambda do
      create_account(:login => nil)
      assigns[:account].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_account(:password => nil)
      assigns[:account].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_account(:password_confirmation => nil)
      assigns[:account].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_account(:email => nil)
      assigns[:account].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(Account, :count)
  end
  
  
  
  def create_account(options = {})
    post :create, :account => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end