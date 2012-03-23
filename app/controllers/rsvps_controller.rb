class RsvpsController < ApplicationController
  def new
    @rsvp = Rsvp.new
  end

  def show
  end

  def create
    @rsvp = Rsvp.new params[:rsvp]
    if @rsvp.save
      flash.now[:success] = "Thank you, we will send you a link to verify we have the correct email address."
      RsvpMailer.email_confirmation(@rsvp).deliver
    end
    render 'new'
  end

  def confirm
  	rsvp = Rsvp.find_by_uid params[:uid]
  	rsvp.confirm_email params[:confirmation_code]
  	if not rsvp.confirmed?
  		flash[:error] = "You're link doesn't match what we have on record."
      redirect_to new_rsvp_path
  	else
      session[:email] = true
      flash[:success] = "We will update you at #{rsvp.email} with new information as it because available"
      redirect_to rsvp_path rsvp
  	end 
  end

  def confirmed
    if not session[:email]
      redirect_to new_rsvp_path
    end
    @email = session[:email]
  end
end
