require 'spec_helper'

describe UsersController do
	describe 'GET new' do
		it 'sets @user' do
			get :new
			expect(assigns(:user)).to be_instance_of(User)
		end
	end

	describe 'POST create' do
		context 'with valid input' do
			before {  post :create, user: Fabricate.attributes_for(:user) }

			it 'creates the user' do
				expect(User.count).to eq(1)
			end

			it 'redirect to the sign in page' do
				expect(response).to redirect_to sign_in_path
			end

			it 'makes the user follow the inviter' do
				alice = Fabricate(:user)
				invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
				post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token
				joe = User.find_by(email: 'joe@example.com')
				expect(joe.follows?(alice)).to be_truthy
			end

			it 'makes the inviter follow the user' do
				alice = Fabricate(:user)
				invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
				post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token
				joe = User.find_by(email: 'joe@example.com')
				expect(alice.follows?(joe)).to be_truthy
			end

			it 'expires the invitation upon acceptance' do
				alice = Fabricate(:user)
				invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
				post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Doe' }, invitation_token: invitation.token
				joe = User.find_by(email: 'joe@example.com')
				expect(Invitation.first.token).to be_nil
			end
		end

		context 'with invalid input' do
			before { post :create, user: { password: 'password', full_name: 'Kevin Wang' } }
			
			it 'does not create the user' do
				expect(User.count).to eq(0)
			end

			it 'render the :new template' do
				expect(response).to render_template(:new)
			end

			it 'sets @user' do
				expect(assigns(:user)).to be_instance_of(User)
			end
		end

		context 'sending emails' do
			after { ActionMailer::Base.deliveries.clear }
			it 'sends out email to the user with valid input' do
				post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Smith' }
				expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
			end

			it 'sends out email containing the user name with valid input' do
				post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Smith' }
				expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
			end

			it 'does not send out email with invalid input' do
				post :create, user: { email: 'joe@example.com' }
				expect(ActionMailer::Base.deliveries).to be_empty
			end
		end
	end

	describe 'GET show' do
		it_behaves_like 'requires sign in' do
			let(:action) { get :show, id: 3 }
		end

		it 'sets @user' do
			set_current_user
			alice = Fabricate(:user)
			get :show, id: alice.id
			expect(assigns(:user)).to eq(alice)
		end
	end


	describe 'GET new_with_invitation_token' do
		it 'render the :new view template' do
			invitation = Fabricate(:invitation)
			get :new_with_invitation_token, token: invitation.token
			expect(response).to render_template :new
		end

		it 'sets @user with recipient email' do
			invitation = Fabricate(:invitation)
			get :new_with_invitation_token, token: invitation.token
			expect(assigns(:user).email).to eq(invitation.recipient_email)
		end

		it 'sets @invitation_token' do
			invitation = Fabricate(:invitation)
			get :new_with_invitation_token, token: invitation.token
			expect(assigns(:invitation_token)).to eq(invitation.token)
		end

		it 'redirect to expired token page for invalid token' do
			get :new_with_invitation_token, token: 'abcds'
			expect(response).to redirect_to expired_token_path
		end

	end
end