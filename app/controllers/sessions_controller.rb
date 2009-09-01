class SessionsController < ApplicationController
  
  before_filter :require_no_person, :only => [:new, :create]
  before_filter :require_person, :only => :destroy
  
  def new
    @person_session = PersonSession.new
  end
  
  def create
    @person_session = PersonSession.new(params[:person_session])
    if @person_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end
  
  def destroy
    person_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_path
  end

end