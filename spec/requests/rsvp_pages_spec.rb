require 'spec_helper'

describe "RsvpPages" do

	subject { page }

	describe "new" do
		before { visit new_rsvp_path }

		it { should have_selector 'title', text: full_title('Invitation') }
		it { should have_content 'betatrek' }
	end

	describe "create" do
		before { visit new_rsvp_path }

		describe "with valid email address" do
			before do 
				fill_in 'rsvp[email]', with: "user@example.com"
				click_button 'RSVP'
			end

			it { should have_content 'Thank you' }
		end

		describe "with invalid email address" do
			before do
				fill_in 'rsvp[email]', with: "user@example"
				click_button 'RSVP'
			end

			it { should have_content 'Email is invalid' }
		end

		describe "with missing email address" do
			before { click_button 'RSVP' }
			it { should have_content 'Email is invalid' }
		end

		describe "with same email address" do
			let(:rsvp) { FactoryGirl.create :rsvp }
			before do
				fill_in 'rsvp[email]', with: rsvp.email
				click_button 'RSVP'
			end

			it { should have_content 'Email has already been taken' }
		end
	end

	describe "confirm" do
		let(:rsvp) { FactoryGirl.create :rsvp } 

		subject { response }
		
		describe "with valid confirmation code" do
			before { put confirm_path(rsvp.uid, rsvp.confirmation_code) }
			it { should redirect_to rsvp_path(rsvp) }
		end

		describe "with invalid confirmation code" do
			before { put "/rsvp/#{rsvp.uid}/invalid" }
			it { should redirect_to new_rsvp_path }
		end

		describe "with manual path (validity of invalid test)" do
			before { put "/rsvp/#{rsvp.uid}/#{rsvp.confirmation_code}" }
			it { should redirect_to(rsvp) }
		end
	end
end
