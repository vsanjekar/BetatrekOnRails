require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "user creation page" do
		before { visit new_user_path }

		it { should have_selector 'title', text: full_title('create account') }
		it { should have_content 'Algorithmic advice no matter the class' }
		it { should have_content 'Begin Here' }
		it { should have_selector 'button', text: 'Begin!'}

		describe "account creation" do
			let(:email) { "person_1@example.com" }
			let(:password) { "password" }
			before do
				fill_in 'email', with: email
				fill_in 'password', with: password
				click_on 'Begin!' 
			end

			it { should have_content 'Create a New Account' }
			it { should have_content 'By creating a new account you agree to our terms of service' }
			it { should have_link 'terms of service', href: 'terms-and-conditions.html' }
			it { should have_content 'Cancel' }

			describe "JavaScript required tests", js: true do
				specify { find_field('user_email').value.should == email }
				specify { find_field('user_password').value.should == password }
			
				describe "with valid information", js: true do
					before do
						fill_signup_form_with_valid_information
					end

					it "should create the new user" do
						expect { click_on 'Create Account' }.should change(User, :count).by(1)
					end
				end

				describe "with invalid information", js: true do
					before do
						fill_signup_form_with_invalid_information
					end

					it "should not create a new user" do
						expect { click_on 'Create Account' }.should_not change(User, :count)
					end
				end
			end
		end
	end
end