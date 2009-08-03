class PeopleController < ApplicationController

  def index
    @people = Person.all
  end
  
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = "Your account has been registered!"
      redirect_back_or_default person_path(@person)
    else
      render :action => :new
    end
  end
  
end
