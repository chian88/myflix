require 'spec_helper'

describe SessionsController do
	describe 'GET new' do
		it 'render the new template for unauthenticated user' do
			get :new
			expect(response).to render_template :new
		end

		it 'redirect to the home page for authenticated user' do
			session[:user_id] = Fabricate(:user).id
			get :new
			expect(response).to redirect_to home_path
		end
	end

	describe 'POST create' do
		context 'with valid credential' do
			let(:alice) { Fabricate(:user) }

			before do
				post :create, {  email: alice.email, password: alice.password }
			end

			it 'puts the signed in user in the session' do				
				expect(session[:user_id]).to eq(alice.id)
			end

			it 'redirect to the home path' do
				expect(response).to redirect_to home_path
			end

			it 'sets the notice' do
				expect(flash[:notice]).not_to be_blank
			end
		end

		context 'with invalid credential' do
			let(:alice) { Fabricate(:user) }

			before do
				post :create, {  email: alice.email, password: alice.password + 'abc' }
			end

			it 'does not put the signed in user in the session' do	
				expect(session[:user_id]).to be_nil
			end

			it 'redirect to the sign in page' do
				expect(response).to redirect_to sign_in_path
			end

			it 'sets the error message' do
				expect(flash[:error]).not_to be_blank
			end
		end
	end

	describe 'GET destroy' do
		before do
			session[:user_id] = Fabricate(:user).id
			get :destroy
		end

		it 'clears the session for the user' do
			expect(session[:user_id]).to be_nil
		end

		it 'redirect to the root path' do
			expect(response).to redirect_to root_path			
		end

		it 'sets the notice' do
			expect(flash[:notice]).not_to be_blank
		end
	end
end